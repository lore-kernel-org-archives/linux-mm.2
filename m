Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69396E9A76A
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 11:01:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90FBF6B0088; Tue, 24 Mar 2026 07:01:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C1556B009B; Tue, 24 Mar 2026 07:01:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D6B86B009E; Tue, 24 Mar 2026 07:01:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6C7A66B0088
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 07:01:58 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E210E1B80D3
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 11:01:57 +0000 (UTC)
X-FDA: 84580666674.09.4B90EBE
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf09.hostedemail.com (Postfix) with ESMTP id F1696140002
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 11:01:55 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="kPUsr/xL";
	spf=pass (imf09.hostedemail.com: domain of 3Im_CaQkKCF87IF9BOVEIDLLDIB.9LJIFKRU-JJHS79H.LOD@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3Im_CaQkKCF87IF9BOVEIDLLDIB.9LJIFKRU-JJHS79H.LOD@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774350116; a=rsa-sha256;
	cv=none;
	b=6PncYbA7QFn4tWM35DceY/xUm8wGtsoNC1zI31v1txy7lX5dNHgxVorogxnew6AA7WQ91x
	ie8Zpk2QyTAUPEifLCJG4HFBovF3KHR0Jmszx7aa9w21gW7nqURBzP+xSmfAGG+SkCs1xQ
	f6RicQjo2LoziKls+Ajx/WRJ/WNZ8HA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774350116;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=abr86o86MPJz2Br8J+2IIJwCu13i3DMn7PEURQveLEk=;
	b=UULS881z545tWwKvac4Z7q47lopZBnCz3EvkeZdmDYyANSoWxgiR3JOFOeBd0U5ADzggHa
	FLIMUMeOohp5JtT2bi6HFQ+zo+n343hQRxeZXiifO1ZO05VyaB2AUBupfRQYyLRRu3QQOe
	w5pickFK90mVdF2VpxYq2owe/IJXqEA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="kPUsr/xL";
	spf=pass (imf09.hostedemail.com: domain of 3Im_CaQkKCF87IF9BOVEIDLLDIB.9LJIFKRU-JJHS79H.LOD@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3Im_CaQkKCF87IF9BOVEIDLLDIB.9LJIFKRU-JJHS79H.LOD@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-486f830f4e4so11104525e9.1
        for <linux-mm@kvack.org>; Tue, 24 Mar 2026 04:01:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774350114; x=1774954914; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=abr86o86MPJz2Br8J+2IIJwCu13i3DMn7PEURQveLEk=;
        b=kPUsr/xLOKgoC3aF4FoIVKgD9Ysor+mU0H5VWaSpHdkayWeJ7K0VrlPgdKJrOcj5xj
         Csry+svqYlzJe9j55gSuyCtBZcPmbNcrReSEdhrTDoWCsFXYLB+es5QQ7W8LIc/x5pDQ
         o4/8M94p4MbB9bmTbw3hO5LHc9EVr/jbPUSTLk0XfGeX71FGyv3wrEGLDi6xQM286Xs5
         tQ0DUKP8q+zNbti1tU+iK3P7cEYLNWK4s/xtpmY0Q+W1a1fCSVIIgxqJUc1mbR7vRROO
         xijykMdjq0Rkg5DHHmEn9Vmq1DX6eVy1RwueRzWZ9KKVzrOq82g2PsFtd7Zgd7BPRgr7
         8t4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774350114; x=1774954914;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=abr86o86MPJz2Br8J+2IIJwCu13i3DMn7PEURQveLEk=;
        b=j8TFmwqcmA4Ly1aN/6d4lQuJ+WLHamhuwcMU849ymtrMbsI83+Y7Z5cl0b4yXY4Lof
         oCdClK0nPb10BU4c5/6sxhMviyrbwmLb/graVOSktFRldLXQER1XlgqPgErIv15b5+uH
         2MAVk3sxSJnBIbvCXaDyzXiycy1o6zhK18c9fU0eQ3GanVVR2+VQY3WZxwxauPt4ccAj
         sWwIK1OpQSHkLaJewCjVwmN8v7fzag6bkAW8BQ4sE6yDS2V+Tfd2mErLuEyHWPlegx1x
         wxP+1KBwcmwLemisraQMUoybOANBvFZeUNBCTdpHVzSXBB4cT2CulM9r93fwm0oLQMb1
         qyZQ==
X-Forwarded-Encrypted: i=1; AJvYcCWS3ar1TX6QYCO0CCvkRGq9L9cWqvAzjtSobX4dDIeh/SZ9QCsp7KCoJpTGxj+LOsqFH9Ze8jAx0g==@kvack.org
X-Gm-Message-State: AOJu0YwZtc8gdKj9oevVGbOAwxlTvAzq0nXy4oto77iJzG+Vm0GPDdy3
	9kcrlrc4O4j9AmzL09Nioh+sQSXYV2M2M48hMpf6T4tfEQt9iJVGVp9C7El6LHLRYFy+pU5qB5e
	7yZVWXrD24sFBwBiZkA==
X-Received: from wmsk23-n2.prod.google.com ([2002:a05:600d:8497:20b0:487:f69:2be4])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4705:b0:46e:4e6d:79f4 with SMTP id 5b1f17b1804b1-486fee0e2ecmr212740435e9.15.1774350114065;
 Tue, 24 Mar 2026 04:01:54 -0700 (PDT)
Date: Tue, 24 Mar 2026 11:01:53 +0000
In-Reply-To: <20260324-vmalloc-shrink-v7-2-c0e62b8e5d83@zohomail.in>
Mime-Version: 1.0
References: <20260324-vmalloc-shrink-v7-0-c0e62b8e5d83@zohomail.in> <20260324-vmalloc-shrink-v7-2-c0e62b8e5d83@zohomail.in>
Message-ID: <acJvIbXjeZdxBlH5@google.com>
Subject: Re: [PATCH v7 2/6] mm/vmalloc: fix vrealloc() grow-in-place check
From: Alice Ryhl <aliceryhl@google.com>
To: shivamkalra98@zohomail.in
Cc: Andrew Morton <akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Danilo Krummrich <dakr@kernel.org>
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: F1696140002
X-Stat-Signature: i4s3szj7qeoyb15s6iuqsemgwmj9uq96
X-HE-Tag: 1774350115-408795
X-HE-Meta: U2FsdGVkX1+7IaTP5pruMdcacRBd4TLHNxVpfqkofWTmK3TOg0Pl8VdQ2mZLzvRWspmm7ofdF1lwbUHthbRwX4yayXFUe85/EYlVx6hDkggM7c5TqrCTzBp/ihkYJMXoGhzbFVInPn4SMX9PbE9X7gzLrRFinVSVJDNITLl7A5dpuIdTG6PKYFUBdf+ss2UPFVhOvOfOBhwCW2HIq9XwEdKINCpe7mWpj0euaRyCgq6rFe/hDEBv/BaUrwywmvf8KNfKi5F5uQeXXsMbJgJdT+o5LS+XXm1T7nPlSkdEDspzy4q7AXAVi9MgwZLtTE1AoPyV90nSpQeSn+hUKc7TA+fvVX1bCZTkrbUFipJszXII+RjotQx4vtLEUsO/1ZaiXGekk4LLjoLhI84FCEytlOVOm4z5nn2rW3aAENQzzZY7QAu5UNWNZ/+4pO/UMt+3m1fijyIdqy6yaqquPIsLK2NbTxjgXqQLxC+tyUSVbbsF6aE+xWOic3SMmIia6+3Im+517gprj8au6+V5NdpKcMSS7EOhmW491XIFVRq/Xq4po8hVm0lpzgI9Hk44ec1y/DG4Z+CBIonYBWolryZx3gu+m+QW2SWSoJexn8GE9XE5LSU8mZxqRbD7XLwhfUiIuU+77wT1JDfBL0Kuc1bnfp9gl9toJH1vsKUg2FVT7yycHMmVr4yk/CdjJ08hnJ/8vHvEo7jJIhU8XYDuwROGZD3K21EjdZp/onBFindZ+o6N69yUnKlqp15UGtowGsialZpzZ6I/CAHwkLA6jOg6e9oFbcwiCRT7xsOnS2bcdpOGSC5weSIX0G4T1zkAZ/BCigU2RG1NcINZLY3bYpAThewfZiUJPEHptt1n7xOL5VSiLhnlsyE25U4aNPPaCK8h39EK5iAswxn54UWp1z2V2xU2nGRwEAmEkU0AyHyOkAb1Or0ZYEZgh9O4EnVGdvn/r7AHGcOjAR8xd2scLjJ
 YD0X3rs4
 UGmjK7m9sjhsQmgj928TbpMmFMoq7XE2vby4yzvLgWh9GCzfp5zg0FUVb5inCq5m403MIKNlP6201eqFIC5Vi0RBxH6wJYs1IG5gzU02ssNKxn0En9KFFnExURtkdkFMxmeztKc2pJDFu9BTwtS3RkcIF0a3S2AkJ7OLvHbDvKzVTF4/5MCYOR7nkgikez2WnXQ/7zIqqevIi/yqX26hGjSHXVpn7R7/F7nCLYIsqpb010Tux3N3EEKKbdUgqSZC9MdH/SLZXXKWy5LuqpPTrWSuHcAfsKUHYqrClt3fIOWwjA+4Va0qMV6oRLus1ghitMdQlYOpvnIX7zejG4pWPxTtgsEvw5jTB3nj8QkNqmscTBdZLvfWb934/sarQdymbLhYG0ryaSD0Yh82456pzNKSiPKyyl3MEAMUJcOpZqChxkMxzGth3cV/sSFGbF0McXSuffqt1czolEHAtClhVLcMMqpjIxFWq5k51QUQYkCemhaJ8x0WUVEP7XijF+6uTjFdZCMrdZXz2v+ZFBmge+HW0sVgam8Xofcchz1GXEzUwxD2X0ZcV6C8+W4b/Ba7RR3ugbQWrCEkuq/hRki9X+rJaIQv7aRS5q8H5uPVqDBHqa2peoDqlnPoSgPy44s7PNmb52HA4C/OVjzSEqEapogWWAg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 24, 2026 at 03:30:27PM +0530, Shivam Kalra via B4 Relay wrote:
> From: Shivam Kalra <shivamkalra98@zohomail.in>
> 
> Fix the grow-in-place check in vrealloc() to compare the requested size
> against the actual physical page count (vm->nr_pages) rather than the
> virtual area size (alloced_size, derived from get_vm_area_size()).
> 
> The virtual reservation size (get_vm_area_size()) does not decrease when
> pages are freed during a shrink operation. Consequently, without this fix,
> a subsequent grow-in-place operation after a shrink would incorrectly
> succeed and attempt to access freed pages. Correcting this check is a
> prerequisite for the upcoming vrealloc() shrink functionality.
> 
> Signed-off-by: Shivam Kalra <shivamkalra98@zohomail.in>

This commit is titled 'fix', but is it actually a fix for a bug that
exists today? Or is it just a refactor to support the follow-up
shrinking logic?

Alice


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D52EC79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 19:30:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C2936B008A; Tue,  8 Sep 2026 15:30:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7736D6B008C; Tue,  8 Sep 2026 15:30:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 614986B0092; Tue,  8 Sep 2026 15:30:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 324AD6B008A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 15:30:55 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0FB8A1C2963
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 19:30:53 +0000 (UTC)
X-FDA: 85191587586.06.F925CEA
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	by imf04.hostedemail.com (Postfix) with ESMTP id EE74840006
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 19:30:50 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=IiVyBZsA;
	spf=pass (imf04.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.47 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788895851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3WttAy6W0orVb3NoJtGLqG6U4/hKJf2+6iPVBiF/I+4=;
	b=17WEzoZwJ//Wzd3KKDZl6RRO1ZhyMTDbRG3D9GWUaypZdoJbtAS0ghK/DoZg1+wFuuvuTg
	r3f3P98KGtrIuRZ7YI/IZMinikePdLe7CS1rr4S9UbReb/aExWLtfXaeWgn3swHOjs9Min
	yHBYQx1nFW8MYNUg4J/2MZ0D4zLMYRs=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=IiVyBZsA;
	spf=pass (imf04.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.47 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788895851;
	b=XZUyyhhOPAXqvHkwea1SnaM/EAfSK6CNV8mNeaeR7BvN4eNsWrWJ4RkxlH2o3Lv6di0T91
	wFO3D2hy3z3hybhj1zvv+rYTmw7T6JP1aOpleprpqoVwBgh7HJXRuR+LvM99ONQuLlHofO
	6pXe/9FNuudhS+zUi8Et29HcJTiMQ6c=
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-91053c27a91so25089826d6.2
        for <linux-mm@kvack.org>; Tue, 08 Sep 2026 12:30:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1788895850; x=1789500650; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=3WttAy6W0orVb3NoJtGLqG6U4/hKJf2+6iPVBiF/I+4=;
        b=IiVyBZsAguxdinCyQr9jGLzweizWrn0WHsc8lkOc/TEjLCFlaoxfaSvhFzwHQJG0Do
         0yuvh8iHo2oFYU0N9Nbkroetx6bKkpf0sj7jmp4hDRBPamaWgpQ82LEKxB6QXckt+P2x
         SnSr/7XN7DovkgTk7iJVNiaJqBKUWnmgnv+fWpOJs6bb61uHvvwdMK7tWpsVztoT5EWV
         HAwrveYRUYONRw/5SB2IPbJQKKL/lKwg7nqKoD0cTt5Akr9Gg/4p968I+PCR7CsPFEBI
         tuJ0ICO4psVByJKieB9SbNTZu8TrIwJSTe6IfOP5GSkUysgMLpVIMSyPPKAVf6fJf7Fn
         F2jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788895850; x=1789500650;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3WttAy6W0orVb3NoJtGLqG6U4/hKJf2+6iPVBiF/I+4=;
        b=Msj5oLAGF5yfcnm+PvShBcYsNTIWjIKp2SCkjMCzxmWlcVifHSMGCVXRlauRxTtp6p
         JFTIXWArhUcwvyjvcM1QScmELklYvWKnnyWD2vhOaxoCDHOBUWWM9aJytGPAsEvTsNmt
         4o7XO13Pz7wYdUV2LvsWy/sAfEwn7RiusE1Y4eK3pBLonzfVQL13ZRXjr1OUCOoMkTI9
         iZI2fw46i9OgL1BKoq5qJQLhtbeqkkSnVdSb8wQECEv9Lsm/XbqMOeRylRzUFa1gUPwI
         h0wGrYVNwJxTR3/rpsGHx7z1L0H999JdyqJIDvQcW8LxIloDAI+f3U5Rorr9pdJ0HHBj
         zTZg==
X-Forwarded-Encrypted: i=1; AKwUvByc+EFV4ns9XlzQFOFwtA4of8hDHN2oHfjvCtmUEmFD7es1kbXVuGdIVQ+5JiDwVYmZKosjFBN9Tw==@kvack.org
X-Gm-Message-State: AFuF++lTNJzt5sasEur/9eai+2UrABrZKervK9Y5K7eEr89WeITmsJuS
	u51aed2xcj3XBsB56/+BBcxFGKXpu+KuBNksQqZNh0MxcLsewN5POWX6dkzvuyQDpY0=
X-Gm-Gg: AYBFou3vGkE5wTvbx2IPqCVGOGkd3rxQCGYqXiuuJSTo4sqGrL1TIE+pdinZ6MOgnhs
	QaX56QwplAVwctFWxriGsJdtNTikCyOhpUBz5ox0zSbe/M68MMD+2pKzpiKcksljVbRc90S4aDm
	qZFA57hyDHyaOh1yz285U/nR7movCaIf6KxzLywPdmFtNyrXVMojuEAG1K1xRbW6KKtwgmlM3q6
	g9D/HvP4vazkUwM1scBDM+5E/PYOa+7enKnwWhU8YIIf4VgbXmqtcJvJ5SKf/213hjvxrHbnMQ4
	7t3boT2lBIagn6XcLWTUT0yT3Q8BPyMQ2TuWi/Yyt+gKgR9FwpFdrkqhZrpwUAdTv5cvIkqyZqz
	gEvfQs0VdaoQpMYSK6VNkguX3I6iAQg4aND8Meb8hNPwn2OgPuQmpePdeHDVU7wG6P26NxNmOf4
	CXFPwMJnIoeOX7ga/a0je1VjeTp1piFd/3CJuHGRmdZz6ZNPXdFpbQzxHWovI=
X-Received: by 2002:a05:6214:20a6:b0:8f2:5a3e:c619 with SMTP id 6a1803df08f44-9103efc8ccemr388761516d6.4.1788895831865;
        Tue, 08 Sep 2026 12:30:31 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-910464bf898sm105133986d6.7.2026.09.08.12.30.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 12:30:30 -0700 (PDT)
Date: Tue, 8 Sep 2026 15:30:30 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Zi Yan <ziy@nvidia.com>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Nimrod Oren <noren@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Hugh Dickins <hughd@google.com>, Nirmoy Das <nirmoyd@nvidia.com>,
	Dragos Tatulea <dtatulea@nvidia.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] mm: remove min_free_kbytes adjustment for THP
Message-ID: <aqBiVp405v2srvSa@cmpxchg.org>
References: <20260901190123.3511535-1-noren@nvidia.com>
 <d202dcc3-d7d7-4e98-a9a5-3137cfbfd041@kernel.org>
 <DL9XL8T6UG93.1T1NSJMI8PISK@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DL9XL8T6UG93.1T1NSJMI8PISK@nvidia.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: EE74840006
X-Stat-Signature: e6odts11d4ofudtohg7jhx3stpfzk1mi
X-Rspam-User: 
X-HE-Tag: 1788895850-221729
X-HE-Meta: U2FsdGVkX19yVV0AS2W1cAK/tKEuIxH4rITBIt629jdomVmCUb9L2FpuEDd6lRlFA9+DU89SuoqtJ+1BJ2ZXdhbIWCIJZqXCzT/G0ZzzzrZrIpq2ccFCq9C0WZbZKtHA0fda2Piu7xJdKue0MgXvEGp4XdX+XzQmy1VOEFrWVYhtoi8NCyiUyC7Dtfedw33ytOvL6AlnfHvxoEyQ2qjt8/XbZ54mPEi/xrgZ6gtdvrwoMmA9WzQeeoPiZPR5wEk+gKdQvMIWmRk1W6sH4yWvE9/ffMhTemqucXMt4OUXDnW/SGfjHir+IJKJubGjbVf32siad+MsKmKheQikB0iPX5QQXXOKg95JGgXkqUR9JKy0D03hih4wCphWcUfWjsMmaZAW8FDBRSYpEMtaBQPvDdQRO91gg93A69vXD8yh4Pjy8Lpp//NIAqkPGZfDgPEyS52uvMNzNkXO0RcS10V13amE9SFjn2d/Woeex72hGmN4csvuBCBYyQp6ijX252km8yvYUAqi4xYBk7CzSZO9a4SR+TfC8wuhPVCK9MVQ6OJwUgggCgof/yS29v1nm/gFf2mz3qXt30c0GlvMQOJAUG90AiEzRTjM85Xe7ILHB+WNllTa2/3q29P4fqz73xso1vUZsnnJgh2fImAj4fHqElyTB428XTlYcVFBJmYsmxAeG1AevohIssBpX3DUW2Ale7ygDTX+EzVZi6rHwFTj1cUdoaDfHjVhzKv+clSbiZtjtiOZNKTMebgNC63lSjBBlLohYVdE3wRu2NpgLXSjFCewS/pVGW40EQArjY+2Ukmh802TRyOtCXSIp14HhGWbrDWfRP5EqzbsJkbori2BNIsx55fUkCzbU06T4TkEou1q71K/7E+4sTE5dK+IrygUN1yhrw8v6mtsS9+EJ21os9JiZLdWI4rToDGyeM4YuecstpNV7K4u+XwXi+6AY//9Od7PDl2iJWidgJ3proM
 cRu0GoEq
 T/yhnA22ywpQJCw2i/4jEVJVErdsOf5vLQgqzgnExvfc/c5OFX2OsXi83lY12PhOBXFtwO2+4S96q3ygnNfTf7quQTG35NVznSu2WLiAMM/0CamcxqmbydvJUXekI7Oi8c30i9Wf63AxpRnx90WNDd99nngB7qDN/EqEsdPR712Cs1cALx8C+Mf+NSwsMqv+QIqoEC2TObY8vTNImZNC3sqW3PYomXRfZQIyDhnnrrI+ELzSI7Ft832TXV6Ace2sM3mgBLX3iE53urp8tFbilfLqQ4X69Dr2gDA3+Zm8OhOTouXJbCV+VPUTobuJ95lfxPiIIpJsNO4sfLtz0lcbGaAaHgAJQTE6NQ+TV5r/7l87hYKf3PzPUGM5KvSxmnePgVgiHFBcQJVR0vojt9Y0W/3mz6vrhTy/ZLSr70E2ChXubV3IsMD+4YgNIUxk84INTxt588pTb9Ft1Iy0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 08, 2026 at 08:24:38AM -0400, Zi Yan wrote:
> On Tue Sep 8, 2026 at 7:54 AM EDT, Vlastimil Babka (SUSE) wrote:
> > Given neither of the patchset versions achieved universal acceptance, could
> > we try just disabling all the automatic (re)calculations of min_free_kbytes
> > the first moment the sysctl gets adjusted from userspace?
> 
> Sounds good to me. Johannes, WDYT?

+1 That sounds good to me as well.


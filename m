Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A654C9830D
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 08:41:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E9366B0095; Fri, 25 Sep 2026 04:41:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39A616B0096; Fri, 25 Sep 2026 04:41:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 289D86B0098; Fri, 25 Sep 2026 04:41:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 030B46B0095
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 04:41:23 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8DB9D40578
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 08:41:23 +0000 (UTC)
X-FDA: 85251640446.12.8AA1E2D
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	by imf01.hostedemail.com (Postfix) with ESMTP id 91E5F40004
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 08:41:21 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="r9FO/Whm";
	spf=pass (imf01.hostedemail.com: domain of tabba@google.com designates 209.85.167.54 as permitted sender) smtp.mailfrom=tabba@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790325681;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o+dFtfvif9TVnSmCofN+O8+24ShzOcRw1mFy/ybi7lY=;
	b=ODdtBY6tIcwQZ8lH5WePJeuFach3oSLd51oQqB92eikeBD99Zc3TLq+yLxg6rKqbtqVw3Q
	xlMVyo064pex51ot0tLfF/eWEMVF10+bQIZnkAq1Q79Fvo10Cr82VhTbXy1PtQq++OQnTr
	YnqNOkgJrYKeGNkdx6cP/8hTqTnEGh4=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790325681;
	b=5Z+Ll999KLyae8lbq2XhlAk3hB7X4VvO8h3c4M/HGq94W4FU1UfikOVIzKPXCDyyJwgxLV
	jL8PkmthSUGkqgoP13Q4vJJXciB7VObx4KBx37GJM0+CL/AnFod35jL/vDBDwdUQoVzVV4
	E6/KNH9+L01SSvZVVyohGUwYp0G9rYw=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="r9FO/Whm";
	spf=pass (imf01.hostedemail.com: domain of tabba@google.com designates 209.85.167.54 as permitted sender) smtp.mailfrom=tabba@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-5b83c1421ecso3932e87.1
        for <linux-mm@kvack.org>; Fri, 25 Sep 2026 01:41:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790325680; cv=none;
        d=google.com; s=arc-20260327;
        b=QdSUmesEdIsEzDOELhY5RAX0z4T8dL779TJfhCjTo5qsOBpD29bdemXdqHVqWsSPAQ
         Oal7JiJOjcxVgadaQZ7oga/CRHBaeY6zRhOwl58LpC/Ux7XBpure3bREIQaIfaYx+aYh
         cEz02XOt3/TNwamnoC24tFpnhj17q4pyxBQFT/GSpvUXfEjyh6EZZaLUmilDiaEhTCct
         qY59pe2Tr9OKzLHsm/JQ+YqEacMJt4ivl0Byh65ZeyZjGc0eCYzsIxwUNdytcfZMkDON
         lrCoYBmOMNgNP+bANB+gkVVFPDpmhIvxLow9biWpkVk9yJDcFtJvYHm11ZzqHSlZbwnv
         miwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=o+dFtfvif9TVnSmCofN+O8+24ShzOcRw1mFy/ybi7lY=;
        fh=lxzzFNiTbkJR2p1UQYlnJAa5n4sP8KMXturDZQPkG7Q=;
        b=o2O/kyTx1hzd2C6+67BfLot2wyI5/+/B0AZ0z2vi8oIkwtc1JbM8m12wieBSewMpWh
         8D8Bv8atxvKaiH1QEDZiZEO6QLWAXMaFcRU3fmhtgMIhSALHpERimdOMFPJlPmgR728T
         P75f34OFur68bsxMKqhqxSk/2nEj8NW2fZvP4B7q9Ji34WYwAEKy1VObcR0L7tHyavVH
         Jg7kD5uT3wCxqvxkIZK9MEDVAVSEm9O1B42gPsNL/bJVnoM3VBjZWXalkJQnkiW/4scM
         eibl3fl8JGNC4UEag8bjeuBv8ryYAT4nktFU2ttLTZ3xfYukrX0g8L1eVuHDCBi19A48
         g43A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790325680; x=1790930480; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=o+dFtfvif9TVnSmCofN+O8+24ShzOcRw1mFy/ybi7lY=;
        b=r9FO/WhmW2ZriUoTh4KDupuW10kFoHEuTnRe98rRFJYPRdHTnewVFk1SJCiBXEaK7a
         37BXw/IJzvs+ph2jzi+aDwLOvZkT0xEJfn6FN/oOELu5LV2igqlcANVhf1spowQygzEL
         apvFmdsoqIuIerG3VbXdPR2DwI+hh7mVRMHyMEuwUrasgdui7byxwdmZ1qvZKrYDPAzE
         fryK/GHY7iS6Tb7Do31LDTtSROHxGQOFtBGi9pWy97PO8wtUpfO+I1hiWqGwDGt8zFrP
         /zuWokMkcbuItwgvr39cftfG/Cw0+Nt8cywLeKsesifB6KnEk04NkqLnyIK8aoYPR5SR
         1jqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790325680; x=1790930480;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=o+dFtfvif9TVnSmCofN+O8+24ShzOcRw1mFy/ybi7lY=;
        b=0xAYDMmjsjKth9WBdkx72V80aoOo24VC/ICa7k0BhVeXsIMNqZElINSimgC+vPOF4B
         fZ1VmB1lwghOSKIq5PBcLnw1QKLWb4IB6wdAvebH17gUM25HCSB8EIhYD95FsInB0NdE
         rfRBVtSWe4A94FKZIF3uDJKc/pVwwkhws3g5qgqpR2eFTVE/C1CutX/CmIpX5jgXdEcf
         2xwbdEyXfHLZphfo7z0StrvYr9O6WwvFebQA4DVP50VKmf4VzIbaZJimBIzXGyo2e7d3
         F5IPZAWY7DbetHYkbmOKioj3D4kPdhkadQlSf/QqHeTeuSRaEzefHEpOClr4QXqIHt11
         j9Hw==
X-Forwarded-Encrypted: i=1; AKwUvBwxgM39q2sWYQTlX6F2tfsJm/9gfDROFqCY9DIoknsf64PLGf+44KOK6E1XGwlaMTRwGimeYjlRpQ==@kvack.org
X-Gm-Message-State: AFuF++lijjpMFY6LhGU8k/m61IjHHnvoW+ja7v8TGeGB+DC75aztMoxe
	LMvfecqdnBeZeilaB53ii8d7X5m4P+H/AdyDnfsKJAMNBqa6cPw3VABABFmIGmD1VCdtHn9HB5e
	UAXgifJi3Y2kHtemBKhEoAknW7LZpDen/5qy1i80q
X-Gm-Gg: AYBFou19ctIZCJ0J+BKrtit99SYZviRe9yJgjBxXVrX+7eFdVDReD/dKZ8azJ6H6DvS
	Y767ttg38luLjw8opoUR8PDXvZ1nzqdTrsuzdqgkr5/Vn0B9m3Y+5Cvzrp4XQxbvncHbQADhrC4
	jL26ULj9GeTzZQvFt9GeNW8RGKInc0uAA8hmUd9u7wPIwZhz182nXVkudwnpvqBuCgXj49hsoMV
	tiDS5s5ULDs1FMZetvrlBIpxRXLJwezq8BEyGlsI1Fvg5IU7/kDs6jUInDxuGxmxH/5SDqzi6cA
	N6Iey1Sc/wJUajC0HFDkyOdeYPpnNzldx6TQmgomftmgP/QqFYEgkwHeVBhhxyYZDfHZPqeh3AL
	en25RSjm+5j249gw+AKF/k/ol
X-Received: by 2002:ac2:499b:0:b0:5b8:e83d:6c23 with SMTP id
 2adb3069b0e04-5b8e83d6d52mr34962e87.15.1790325678596; Fri, 25 Sep 2026
 01:41:18 -0700 (PDT)
MIME-Version: 1.0
References: <b91dbfae-20f1-4b9f-a25b-4397afae80f9@kernel.org>
 <16ffff40-4ef0-4312-a700-348603f05c0c@kernel.org> <CAEvNRgGW_VHmT82q+bUqHh_5G2Z9sUF1jJOTiVN4Z8_cA9A50g@mail.gmail.com>
In-Reply-To: <CAEvNRgGW_VHmT82q+bUqHh_5G2Z9sUF1jJOTiVN4Z8_cA9A50g@mail.gmail.com>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 25 Sep 2026 09:40:42 +0100
X-Gm-Features: AclHuK8wuRNyKESPsObp4QvTkrVR3_lCINqfI6LnWNaBHbsf2BpkSVcq1Eie6oU
Message-ID: <CA+EHjTz+WgXEW5RTxXf4oGeEb1Tsm5Ha4nOc4S1jBcp7jxP4+A@mail.gmail.com>
Subject: Re: [Invitation] bi-weekly guest_memfd upstream call on 2026-09-17
To: Ackerley Tng <ackerleytng@google.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	KVM <kvm@vger.kernel.org>, amit@infradead.org, aneeshkumar.kizhakeveetil@arm.com, 
	ashish.kalra@amd.com, dwmw2@infradead.org, eberman@quicinc.com, 
	fvdl@google.com, gshan@redhat.com, jackmanb@google.com, jackyli@google.com, 
	jthoughton@google.com, kalyazin@amazon.com, kas@kernel.org, 
	kevinloughlin@google.com, liruxin@google.com, michael.day@amd.com, 
	michael.roth@amd.com, mike.rapoport@gmail.com, mvaralar@redhat.com, 
	pankaj.gupta@amd.com, papaluri@amd.com, patrick.roy@linux.dev, 
	Peter Xu <peterx@redhat.com>, pheragu@quicinc.com, pkondeti@qti.qualcomm.com, 
	prty@google.com, psalian@google.com, qinkun@google.com, seanjc@google.com, 
	shan.gavin@gmail.com, shivankg@amd.com, sidtelang@google.com, 
	suzuki.poulose@arm.com, tatashin@google.com, vannapurve@google.com, 
	vbabka@suse.com, wyihan@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 91E5F40004
X-Stat-Signature: rf67ybqifrny4d6hm4dysraktbq883zc
X-Rspam-User: 
X-HE-Tag: 1790325681-386234
X-HE-Meta: U2FsdGVkX19vsXnJJoG6QTBLZqEVDcihUOlfsPW775y8k1OxgeCo5Qh/FNIMqN3liJzxNVJpr/7nY6O1lGHhqIStdnHMY8euUtSZrxxvAG1w3fuAeEtQivyinN9C/MqFf68xrGTs2TLOZtwarTYi+OVNof5L44HKWn59uJW0vwnsgFFpQ3Qw6Tzrvg2Hh4uTN0WaqrV72fxYSVJTMtuerLiYUPFYpurCnwKBx7DrDW5j8dvfGSjt2HIHrgiLPhGj3CW5Jb9+uu3Wg724zFERYA3d/8vrjRYsN1GtlS6iJF6LJZntRzHlWZtG+z/y5cUr6piY37NSXovpnCEHKEeHIaknmYJRWAkErwBgc/FN5806gOzFSepMj0E/AlzopDHwqoCPOZ3ccWYF2g9qlDnqAI5Og5D0xSy8SYfvgBjJwU9v62RcoixpiV2Uvdiq6LYhMJzpA2vxbNdsvqCAHO6ih+80yiGbp8tpFNDpIOAoOLRcBrYyy8F1ZTb7SpsZFrcvH4K4oKFzN8kBpCEM3t0aQdsLY41AhqI+JuHgEG2TwPwXAWaN9ajB18rV4RQ6u5fN3PfzVWybAvrKUIzzwLiXR2t9EeGtOAMXwAkNN3xiSnuJ3qiNCOTzwYO2ksOd5Azp/cHitEXbVFJ0qHY43yxwP0n8DxxyIv9SQcNTScj28wmOzofF7HtciY7jGelId0hBcDmnNaS2PP3rPCsGYdLKKfvYrtmOJdVMG0m2HRAOiDNNFuqSHVa4VpFTN/+dSfBUb2d0xEk+5AyvXxTTFWfsi6D2ATlwhBvRxW/pJCLpobY32+Vcbo1EW5FFnX1xVvomRmXT2+Bghzx789LBBDFjG7M8cg9ik1DtlRwrV9h74rmmYk1400Sx1kP5KItZs5eWVY8NyBccC/RLX2qWCGg7y3XI+6AVc7xFbI2pwb4XeYNYYtrPmTN88Jtqm9h7SCphGh+l3NeCbgwrNkqj0+b
 1n6ABL1c
 8NUJr0UxhBQcy9swtmCynora6gvSxy4Bg4uIb8SUIDTHkjyNplO4DGKjNsRaeaFm2Lt+eTrheRDyWOQnB2DSOW0VtXleb6Q2FlaOvSkmzzGWZ9BbaCw5dXgTJI5rkj01j/Z4YlXpyXu2Wlc9UayqMKez4tqM4N7Gaxoehpk1z1HjxSYrno6MXBck09Ky3TLNPwO7iUTnbEWbx4eZ4o4G1IxH1MXofsKyO1sgeTyO72fuchHRt5L6lvJs4zPDx7+VuRXrdGIfzlsFtyO1cEPpzhcdHzVyRv/GVrUSD8IGwoqw/P6QJwGCxO3U6EKr8xEcP8/U46yb3mLStGPe/TXt8MuwDAsnW24Cbd8YuTuvdSy83kF+DAO75zASk9T+IW9+0NZ/WJvo78bUYcmRbJzTf72VMlImbleO/9w6P+jqoEu7o+U+nTVHh89HXZnFA93T1XKXebw2xT1+Tx6eH2AEG7cNcRg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Ackerley,

On Thu, 17 Sep 2026 19:41:14 +0100, Ackerley Tng <ackerleytng@google.com> wrote:
[...]
> p.s. Fuad, for pKVM you also mentioned that you'll need to check if the
> guest had requested for conversion first? This might be the same/similar
> problem.

Sorry, I missed this.

Yes, for unsharing. I'd said EL2 does the transition first and the
host then accepts the conversion [1]. That holds for sharing, but for
unsharing with guest_memfd the host would have to convert to private
first, and only then could EL2 complete the unshare. Otherwise a
failed conversion (-EAGAIN) leaves the host holding a page it can no
longer access.

As with CCA, the unshare would stay pending until the host checks on
KVM_RUN that the range is private, like the check Sean described [2].
I don't think the per-VM list in the host is required, though: EL2
already takes the VM's lock for the transition, so it can track the
pending request and reject conflicts there.

Cheers,
/fuad

[1] https://lore.kernel.org/all/CA+EHjTwLRzrq0vY0-OosENJ2Gkknerux53aVBj0zGRQUkRQP=A@mail.gmail.com/
[2] https://lore.kernel.org/all/aqw_uBIYig_uo5Eq@google.com/


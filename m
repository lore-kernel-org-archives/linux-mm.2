Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DFC1606A33E
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 20:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=pcblL+kz
Received: by kanga.kvack.org (Postfix)
	id 8084F6B05B0; Fri, 13 Nov 2026 15:53:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B2D26B05B2; Fri, 13 Nov 2026 15:53:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6527A6B05B4; Fri, 13 Nov 2026 15:53:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 366D86B05B0
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 15:53:22 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BAE161601F7
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 20:53:21 +0000 (UTC)
X-FDA: 85431296202.20.5A38BD8
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	by imf24.hostedemail.com (Postfix) with ESMTP id C03AC18000F
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 20:53:19 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=pcblL+kz;
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.47 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794603199;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MSDd0mIYLOoBidzRJM/vL/FHkNZCGR1RZTFok+0qNYU=;
	b=aXTNbNb95NI6I4LyQpBpWzORKBc2EV5hsd29P0lVPS/PuwcHdLc/0alTAKxSdwShk70YW7
	cIv5fy/0OZ1bAQQau/qjSg8eFeLYu++cpnA/fExT6qZODUlX7CE/vXT3rshYADJi/mAnHF
	K5nOF2s+uRZrRAAVwHJUTn8AUozAqJA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794603199;
	b=H73GvjCdd4n0V6X2bhwRwtBOjKd3+zriCPABAZJx/MM6ctLV3FeCxn43DKPz5h6i63euf2
	0T25ir4hNKDX0ZUXUmGBG+Uml6LAHIoHZxm5MC5rWyyrHakpBagl5UKAFqkwk6+iFBMpOC
	VOK4kjcsKgDcM9NqGQZkRBUmLhjaGYw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=pcblL+kz;
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.47 as permitted sender) smtp.mailfrom=gourry@gourry.net
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-91ef011e338so26358006d6.1
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 12:53:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1794603199; x=1795207999; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=MSDd0mIYLOoBidzRJM/vL/FHkNZCGR1RZTFok+0qNYU=;
        b=pcblL+kzLE+EnZsNvq4YdELz/qaSLOjQsJTUnAggYaaaFnJG7Y4TAr2mERWZEpgyNL
         +jk8lfcx3zse/dhYVLNn0nEr+eNG1cD4l2bXAbFq3l574guN+30e/iLsIE6yn7J7EgdH
         6mU9Msn23YCEYBtUSlSTeX+Sd/PbLXE8vBds6DYAxUVDkilRQHI/AbdcSOUmTEV/otFN
         GQ/XX1D7Yks/32wdbWHFYMKy6yQ+MxH4qVJoD5jO4VqD/HUpxbCba3o8gdqDWU2kxfEu
         MesMlMYhPhC94MgUjTo31gdIVsmQFLjXhsUaC0VUYT3ju0C7Wuh9s+cbzAxTPASZkiN6
         3xyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794603199; x=1795207999;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MSDd0mIYLOoBidzRJM/vL/FHkNZCGR1RZTFok+0qNYU=;
        b=tA9nlsRKZYhLW8iF6CFGCUf+oBPefLzQbt9WNcLDQ0R9J06GHiQRrkX5zl8OiqFl4P
         FQ0/TQfzPoM3p5xOsQ9UAnYX8sykqK7J09gj5t0M2A5w2hbLoyFWP+Wx5jAWUb8eTZMs
         lxnp5cngfpDtJ7q+ZaGwHMiRpihEHS7dgsAusBJ6EOvehfNhpY0GQ2Cv7DyhTWCp+/cG
         4gaFgkZf2Lb39qWA194C8NMwpX3PiViF66Z09T7GFcKBPlH0tSMNIpAe8o7DS4qtgDUT
         IhTHs6D4NTRnMeu3bpBhraCB47kQ3HJxLnYq3yXl5nvYlvFnaGAbHjuDTYAmZrFtcg2d
         8Duw==
X-Forwarded-Encrypted: i=1; AL+hErHErR9SSUpDqkX6ipx26Vee+aFCjhTFEbvl96pkBhbGZbbWI/DqaTn5HUzu6nb0XJTdp6E8bSUxbg==@kvack.org
X-Gm-Message-State: APuU4Z+2zbaJ4tjQ/FoXgwKulwcmlxngt6h1jQ75Xidc8td4QXTJvUXD
	zHRXkTUwoWhpciNV690dKbdMLsYV6okrNjxX9+SYAw19xpcFqOcPJZIKw6vFNNQk1GA=
X-Gm-Gg: AYBFou2G25pDuQG9hTj4jf9gRzkxAe19QuQnzz0cfd2PQWO18JBHlAoXIlPVTnppFdl
	mq/ZUH4SYocnkGfsScuYSboLeyHkPHO6++44ThNA9uVryxgcVUmfqomf7zI5VvuWEwznR0f8Vvu
	dUcksaeDhkooMExRa6W/T/xQ9p21OVsdnkHzlTnUNIo/5vjOLtRQ1v/Ch62pC1Fac1B8uTbc/xn
	tb6/DiRyzusuGuAjhpXruFGsFvUqS95P92uVMT2dMAO5H+jrBwx7mjYxh3txBRnvg6q4RCAvIeh
	aRanhBQpPoBVBtpTjmtO32G7pjSmTGrbyRoiwLCm2VXGNsALbNJmoPW26kqZ6oB5N69igYI0Jld
	5JjqbX733RUYeBNIqaDzWXpiXc8NiJqCD8nYJgOz7GCaIJf1Jje+g98m15g3pINWymjufCLOhP7
	RFTYuxcHsADez8ZbuPmkVkglSDTto3o/VE/mwkAtrYpJB+kAD5woJSHSnI0DGQu8f1ldhLqCXvv
	1/Ymy5gqeqtLaavmE3u78QDHK0+5si3so0QA8TUsvVtC3RB3J0+/Zmxq2W1MpcQ2zdXstLk6DmG
	D+W14olbR9INauXKRUBO8zj6mynk4HGgjquYz2EE2EYSXghf0REx+v5kermi4MbrWcOhqucGUlG
	/d/Hq9qg=
X-Received: by 2002:a05:6214:8583:10b0:91e:a6a7:73a9 with SMTP id 6a1803df08f44-91f24193e70mr44399636d6.15.1794603198962;
        Fri, 13 Nov 2026 12:53:18 -0800 (PST)
Received: from [192.168.50.231] (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91f23d453casm28237866d6.10.2026.11.13.12.53.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 12:53:18 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] mm/hmm: skip NUMA balancing on protnone faults
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: =?utf-8?q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, 
 Matthew Auld <matthew.auld@intel.com>, linux-mm@kvack.org, 
 dri-devel@lists.freedesktop.org, intel-xe@lists.freedesktop.org, 
 Matthew Brost <matthew.brost@intel.com>, 
 =?utf-8?q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>, 
 Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
 John Hubbard <jhubbard@nvidia.com>
In-Reply-To: <9ec3e8b9-064a-47a7-8d00-566ff371b846@kernel.org>
References: <20261112-numa-v1-1-ad9cbca8f49a@intel.com>
 <b32fb02a-68b4-4db9-83dd-254147dbf215@kernel.org>
 <1993e931e6a4b0cda5c04e72b1a8d5fb924f950a.camel@linux.intel.com>
 <9ec3e8b9-064a-47a7-8d00-566ff371b846@kernel.org>
Date: Fri, 13 Nov 2026 15:53:18 -0500
Message-Id: <179460319801.482102.15329919214055018110.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Stat-Signature: pagy155ubgtfr6xmefnfjxahu1erjcfj
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C03AC18000F
X-HE-Tag: 1794603199-700302
X-HE-Meta: U2FsdGVkX18jLlNjfoHWjVlzlBgIpycyJM8bhm5zAHODJ6RT2YIJmO/kjBLp7KFDyG/FnhO+9Ha0K+RQLXJwP4ICoPS/R6D41dDYujS9ymWcFMAZRlAuA5HURwwYB0/Yn3nNW5CgKXpzxC/ihQ7SZBrxTkB2TSEWJ1FNUzwpvEdz9zKk3ohVKm/wo+TXMx/NWPiARjEKEHthot1fj5qGI8ZpAATIWJ1uqeRStc87EanutluKM0FRFGbR7ZIXsmLNOWoV0EPp6G2NpV4Rf3S2wW3Ue0XBCys1j2Gf+39jStPL2zBeToDxesajUU/1p4B5ceZLF3Yw/WmqP85Gemf4Rqlkk6KWYPqgcwKtVzk/VShNXtRgIqq9bWrz/KjIQ9r8NB5IvYoI4GOCQTp7/nQT+QvKeqnkvm+F/hhcWPrRbDSAvvuBcdNiid3BIfhTofjq9iZySa27yrTE5/faDf5RojN6Fb5SZsjZZozbu+ULYgVlohMu+PkBNZPHcxIjetEqo92vqtQjGKEoKFSGGcnG9u5RU3/5nE7w5NzJ7MhoPsxhHHx9adnKUDGyLUiyn1wE/XBRjlYqL7KcL/VBaE6o2RojntC9sbzs2jgvW+mmk4sCJjB+Yx+76kPkNV57zF2zkCruw647FCGw24Jf7Mj++4++7vzIwfl5cYuXWuDJtul9xfvksJamSn/eMuPeBZhsRbcG556UaVTc4kAcVa0D9TkRoIkl1qtiw6O+eW5mG76iKnUNmUHnP2AqXqR7DDU7lpXydelN9zjCbkBQcbFvGI1F78S79/In0IoaVXJ2Z2T1DzhSNZponqE+6HzMn3wFg7Sgf+rJwo9SK5lnhH2ZSMBvXoysvdd5zTEc2LSgWQh3bx+32cMXgNz5XU715T5wIBmGoT0sxs4v+dQYIUzms243UtOlF7w7BPSouDq4ZNvuHLhDt6WUVGPib7cK9Nbh563RdtRpCH3UPkve0LT
 lZRpWHgO
 EMBi8GsDNSlMuZN3Wui4id6YEf0s7o2fq2u39VOdLeXGicwYe5S3Hx5QPemm5DBsphxA701ja5QFmih+9gVb2JLlK52zj9yx3PAs0GmuCzvjd4FD6BszG1h1omxWO50yMEA6jjNCtfzfedaXaNYWqFlzynFyfYFNDwoPkghVmClnWgb2or71zqrxYrMK7nXl8QWsDzriWZgegaW5IwMUBgj3PKDM1uzDgO6T4l/OJ3HHv44/mjz1F7gHlqbVsvkvoijv2OlCIrBuYhnEyTjl26D5TBA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-13 21:43 +0100, David Hildenbrand (Arm) wrote:
> On 11/13/26 21:34, Thomas Hellström wrote:
> > 
> > There are two major problems with the current behaviour.
> > 
> > 1) The work item executing hmm_range_fault() might have no affinity at
> > all to the GPU about to access the memory.
> > 
> > 2) If migration happens, then hmm_range_fault() will stop and retry
> > leading to excessive execution time.
> > 
> > While perhaps Matt's commit message doesn't correctly describe the GUP
> > behaviour, do you have any alternative suggestion than to avoid
> > migration in this case? I think it's a reasonable idea given the
> > problems with the current code?
> 
> Adding fault reasons that hack around NUMA hinting such that a actual CPU
> accessing it later will not trigger ... NUMA hinting?
> 
> I might be missing the "reasonable" in here :P
> 

Ehhh... I think the hint faulting code is already very tenuous, so yeah,
lets maybe not try to go down that route.

> I recall that John (cc) kept saying "GPUs and NUMA balancing is inherently
> incompatible, you have to disable NUMA balancing".
> 

If this is a NUMA-hotplugged GPU, then this is resolved by a private
node, because this:

@@ -6404,6 +6404,9 @@ static vm_fault_t do_numa_page(struct vm_fault *vmf)
        if (!folio || folio_is_zone_device(folio))


changes to

        if (!folio || folio_is_common_memory(folio))

And all folios on the GPU node are never subject to NUMA Balancing

so balancing can stay enabled while the GPU memory is not subject to
PROT_NONE spew.

~Gregory

-- 
~Gregory



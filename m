Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D98AB606A31E
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 19:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ze3iW0q7
Received: by kanga.kvack.org (Postfix)
	id C11C56B00EF; Sat, 31 Oct 2026 15:28:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC1686B05B1; Sat, 31 Oct 2026 15:28:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB1206B05B2; Sat, 31 Oct 2026 15:28:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 819A36B00EF
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 15:28:00 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A169714099A
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 19:27:59 +0000 (UTC)
X-FDA: 85383906678.22.7013C1E
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	by imf15.hostedemail.com (Postfix) with ESMTP id CD434A0002
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 19:27:57 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=ze3iW0q7;
	spf=pass (imf15.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793474877;
	b=8qSLyr0blRu4A/m/V51sfX4+moXYF0Loui99QMFe4Rfn/COPvTzPOuajwxU7GdBq18DLwz
	C9+wbVO/d4nr/yb8OCQdGCasdoDf3njSi8qQrP3Dq1Mid1b7Ad0MIAAsTHTB91Mp+5Uf2T
	BcyGBf/8D4aLejY7/k8el67jZr8rvC0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793474877;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c/gnKk2+sniHQkIT+FGrUUN0y7Ag+lC5S9EVpOY7Ua4=;
	b=CUlkU+bG1YjqK9Jm0RskpNwtXI55gNhKjCwYwMz4z0CJXhopX0Fhw9tX8TdyEXxWGqKakX
	7CwQ41B7mwARHYe2KTzgy4ycaHkjnB/kjeDjwMUuTpGvMk/a1u2UQhjCSt5xdPoVY3OXsJ
	Wh7bcviU/cJ+T8mttsqfjoB7yECrW7c=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=ze3iW0q7;
	spf=pass (imf15.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-48af4d4e61fso992076f8f.2
        for <linux-mm@kvack.org>; Sat, 31 Oct 2026 12:27:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793474876; x=1794079676; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=c/gnKk2+sniHQkIT+FGrUUN0y7Ag+lC5S9EVpOY7Ua4=;
        b=ze3iW0q7KCR9jL/Q2+fpo25e8oyE6FZGHUeULpxoUebo5rhRTdi5VFkQACPpD3bBNl
         heX7WfuRAnjRWXNxUH62r5+QwNxNd99MaWfzZJi6nvPRZG0mnVYHBmLoq/IUyMHGD8Wn
         Jm0LITyveAzNaatYod6AlX4scHQOwrsqRbMCUIxNpcWYCRbVXHZr+aZEgbck/J7imnbe
         9kmCj6JivhjeEx91IC1aOsxQ7yQdr9135e51CVQo4c1d9L8MODCtanF73iQMLO/tpV3/
         97sb/XV/oMP1dFa5aCX/x860F1QMRkqNUtL1mVQcYaysB5Axhi8vuQdCuyi/WxCiRseg
         FL9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793474876; x=1794079676;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=c/gnKk2+sniHQkIT+FGrUUN0y7Ag+lC5S9EVpOY7Ua4=;
        b=wRKOhaRbM/D3GYQ0ruiY+hHjIyqzWwNp2S0zpykthE2xhZUjbb9rwrl9wOE1NqmW6X
         MFVo5w8oWDWMNo+aPoefwAIcGWqE/ElDciCJhAQgmVYncenGjYnmUIYtQqwkafwB7If9
         wdZfxS8lFieBIHPSV86g2qMp4nO9xc3/acF7uVrlVSP+tDUBcWEbJCjfgVGchA7okLCf
         I2aDl5i+IKfN9drgdYApAgpHwqTG+WkzhgfaUt/WCAN7Od1J4tkPfgek23tPv1eEYrLi
         MeuHl8EqXcfSSxfdjCzlsqHDr0hfDqsuMrd6b4k09voZZqII64EsehWo+xNB91HtyZmS
         zzMg==
X-Forwarded-Encrypted: i=1; AKwUvByziNwLZ6HoFfo3nwCSIU934NniyZl/PHuop8SQuXu5lrExyIkQRJw0GVvosDiuYzXQkXENg48SOw==@kvack.org
X-Gm-Message-State: AFq9FYKUSqkDHbXJanst2nL8Cj3r2XFsNfOYH9ju3Xgbi6mvVXbL/RDn
	niVgo4+nYGQ0QnuSjXAUfO39K81rdRbki71XNJI4NC+j+r0UrugJpiEW
X-Gm-Gg: AYBFou2TeSZMn3jducSsh6MaZiZR0KEXWAUskVnMnu7NTNK0RkmdL0m6y8uEnRbym8y
	n3gdUNqJ11YTgNatfxJDf0y5DDgJaZjpm6vNIVuQvlVT+kATkKdQ8pOG9J/8f+E26oZxDP5DC9y
	u+wyKTCyli4pH2cddfG5kF0njSfUgexptkkZpQznVjdvXddGSUc9Oj6ojI5U/+R9Yr18OyWeQG+
	NjgiLQ283aZk2EZXGqdrghcTxy/Q6QeeauDg0zbB2pjsfufO6r/LKpfMjN9dY34QUR3K7wLqhoY
	ZMRqbr8+LiOQObXTgRcYecE0eXsXtSJlFB2ML+yL0DOtexm3l8Cc5td7/KmPGO3OyrnXA8MtxBo
	S71wAHQNqs2QpkRpNnwcDf/R58GSEiNQCscX8zxLchu7J/ULE3fnhpe+Pxl2JF7QqbaRIkLZKbc
	blzrTh2dPVNCbwSZZ5bchxmnBjrETPKs0H9CUdAf9MUKWTdwXzwj1mtg3W47qt1i/UvNa5OLR58
	ddwkKEzPmTzOn2Wq5CEidiabojEOeJC+xMRC3GjsG8rzts4IoXYHYT1zjEZXPzhl6HBIefCrBH/
	0lgkKCCf8YbKHPNyb70HELysgA==
X-Received: by 2002:a05:6000:26c8:b0:48b:677:f80d with SMTP id ffacd0b85a97d-48e6e2ff7demr12569827f8f.26.1793474876057;
        Sat, 31 Oct 2026 12:27:56 -0700 (PDT)
Received: from [192.168.1.22] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71a4d3e9sm11383388f8f.6.2026.10.31.12.27.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 31 Oct 2026 12:27:54 -0700 (PDT)
Message-ID: <6f7c7b4b-6bc7-4bc5-bfec-86ef9263d7a2@gmail.com>
Date: Sat, 31 Oct 2026 20:27:52 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/6] mm/mremap: split first so a failed split is reported
To: Josef Bacik <josef@toxicpanda.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, David Hildenbrand <david@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, linux-mm@kvack.org
References: <20261030-b4-mremap-pre-split-v1-0-c1829811aed0@toxicpanda.com>
 <20261030-b4-mremap-pre-split-v1-6-c1829811aed0@toxicpanda.com>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <20261030-b4-mremap-pre-split-v1-6-c1829811aed0@toxicpanda.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: yu31mre89fjym6o4prndcbe41ej3gc3c
X-Rspamd-Queue-Id: CD434A0002
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793474877-27056
X-HE-Meta: U2FsdGVkX18aduED6ovDGAPMISugBCBtBqPGdkt57O54fzDLaRjqFEBXd6Tc2KDvTSLNjz9sqY87ZwKzTAgsHKW/hIz3/r2nDgYDlL9hxjXfL2KQx2KK3FPQopNnhR7QYDZauGNYS/bs6LGLqHg208LuaUwcfZpXroTu5TrqL5TmuB8rc8CKMbks5ub2h5NIfCTH3cnZYrFsWecyFApgmIDZty0Xp9WBj395E4gRVaSACYqlRXsn5gy/2Jp9nWBCc2LXcBpduOYcp+XUh3A3aNwVSq/kGZxmmMtDdlB4BQXCTGkhk+adOwL1+DsIMcDLWlVo5azHtt4N+3o37bmg7UrBVSezOnqEeae3JKrcP7/+rtalwb8Co/krrXKlaQCb57f5iJVbpAPjLNNtryAZeJ3UT7obK+uCnpTRkzPVhuCoHapvPDvtZ2uDsNa8QyKw9LVR+nOsb+9gswbwyfQ9tKUuIRucKfzuFjm90X/ZyRZvY6HsfY2p1w6pfQ/b+i6zjPVFxWrUsafBVRclqqVIKapz3gbECrPm9AjFhqbBOTLPOgPDNf5tVqPLruhkk/cU2QvMkXW/tBPqubKexML70DO/IWCODPGO+V4r6WnxRNJOaE+W047h+v2+3r/5u7wVjFyWMN6wYPfbcEg+N2gQRTQ3bUmlMNMpgy3+Im5TMNmHBcmHWS1rDr+o78fl8lmC7ZwG11j9IxcAEKdZD0x6SBCCFjTfm/3RSlHpyjuVhSV+rEAPdVYbfPI12z9IuVcKKiD4mYylpPB7v7IZGmsf3oTB1c4JGwia5iYOmgLlM5doTE9J63vfsoSrIkM3p5ZXIWd2y5SNS8+X/f80W7WmyAU+cfLX+141jkEHag/aJGa+0YJfFEsR0V0rZDJSzy5m10TEPlIVtqJqsiYhGNx1BZfbjhyxzdq9Bo0vFmadAafHFzZwwvzXg0GOjwiQrL3HNdL+ZSH4eVHh7TWPeyZ
 11NLd6TQ
 BHUplSXUc9jMd9eGNwxZmUDBoMGczVpm+UJD2fOlbwT3EfjBIMekznRYICdEq7tW8VvjC9/R/Akl0h8o0YAx9y9Fyh51owiccWAsJwI1f9zWRwQjwq9lM2Cw0ph6+E2WHf0VDbIlzonn2ZYIpQDWL4feT2Xuc5OUx7byNW7tDwLFQObg6tbcqX3Xjynm7QY8JHfZBAGe0DS/fsEicCVxi0H9iduYqJ5Q7fvQa/zZ/hBsivUt2GnRoi+bNU6G+x6lX3bh+cW0uJ4Y1tam0tM2UBxMGJy6whpwUn06YINwN1Rkj3iFp9Ec8XABTHNwfJn8xPtro/JBQOae9Mwcq0qIZL15LozLQ7Gn9RFz5/84nJBaLrlEzTd1O1yIk795Q/HDxvDG1KYPLwMjK1ov0fbG7heQVH4NIVwqB1+AVBO/a2iTNbfirofl4zTP2UrfJIHwHhco0vPQCeGQCO+TEKVCHhm/EDC499COMJM2FKWVVPzO8x9E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/30/26 3:42 PM, Josef Bacik wrote:
> mremap() can return the new address although the old range is still mapped,
> which leaves the caller with a VMA it does not know about.
> 
> To move a part of a VMA, that part has to be split off, and this is left to
> the unmap at the end of the move. If the split fails there, the page tables
> have moved already and there is nothing to go back to. unmap_source_vma()
> returns void, so move_vma() reports success.
> 
> This was reproduced with fault injection, by failing each allocation of
> such an mremap() in turn. Anonymous and shmem mappings hit it at 2 to 7 of
> 7 to 13 allocations, with numbers that differ from boot to boot, and no
> longer hit it with this patch.
> 
> Fix by splitting the source VMA in prep_move_vma() whenever it is going to
> be unmapped, so that a failed split is reported before anything has moved.
> An old size of 0 unmaps nothing and does not split. If a later step fails,
> the VMA stays split, as it does after a munmap() that fails half way. The
> unmap at the end can still fail in its allocations, or if copy_vma() has
> merged the range and it has to be split again.
that later step isn't always an allocation failure though. a partial
mremap() of an aio ring still fails -EINVAL, but now leaves the ring
split in three. is that intended?

-- 
cheers,
jose a. p-a


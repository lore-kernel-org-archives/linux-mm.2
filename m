Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29807606A337
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 06:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=Y6rBL/cd
Received: by kanga.kvack.org (Postfix)
	id E7CA66B05C2; Wed,  4 Nov 2026 01:26:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2EF36B05C3; Wed,  4 Nov 2026 01:26:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1DE36B05C4; Wed,  4 Nov 2026 01:26:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AE6CC6B05C2
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 01:26:02 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2F6F41403DC
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 06:26:02 +0000 (UTC)
X-FDA: 85396451364.28.A56DECB
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	by imf03.hostedemail.com (Postfix) with ESMTP id 57A9620003
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 06:25:59 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="Y6rBL/cd";
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of gourry@gourry.net designates 209.85.216.47 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793773559;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Eed9z5suww4/zRV4jVvjzbO04jNWYIPB5y+W3yGdy9E=;
	b=yPvohBXHCmKHrB9+3wE1YS0QFw5NhnYLUAwpQh4kuyXZIRx9qKzT8Xj60HC0IUgA9r45uE
	mRP8UuBHjt4mtW7YOCaVfkrNz/fcn/k3xTgoHn9TZbPsabGTfQeIvZY9ztoaZksF08hSG1
	6vxUViqKJnzrDf8XHLp7C3foOQwOGg4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793773559;
	b=58IhmdbPjXHR3jFTgOPv+ZQcRFE5UnIb7xc285WD01ldpAMGmjwdCQBLx1YOwwDrU1inLk
	qMLG1rPZL5TezikMHyGIKb3ntNe/8cLo+iY9INRCnhWhLBbI88TlJ+B6qfrs+eRcvAfDr6
	kGGZQ6lVz079lsOBaMA8MdZqfzQqsPU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="Y6rBL/cd";
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of gourry@gourry.net designates 209.85.216.47 as permitted sender) smtp.mailfrom=gourry@gourry.net
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-3b08a162d4bso292820a91.3
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 22:25:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1793773558; x=1794378358; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Eed9z5suww4/zRV4jVvjzbO04jNWYIPB5y+W3yGdy9E=;
        b=Y6rBL/cdsVWG8ZM/AFoLfHjjPAQFf66PjXwCSLaKvL15H6usb/a8rqaeVEHxzlXbdA
         HKjewOMzH3nqAR5cdurCMTUWoQV4hrn5LYsmVrUN3tZkSkF9EIWZ+gTBACkCrJd33k7K
         Zxykr2QgoTrl9PfdPCoaOW8DlZAmCHbxSbhxKYHZyU2efQLNAyq6UCLT5YnjBXsIDu3K
         7q2G7RgZqGHroJX54HWWkIjCDhd1WPfWU1uTyY5YPjsRglIuKwCNLMQu0Os/emhomf+w
         kBSkGBiLoAwtAOzmMzO6n0oDVCsDkHzr93d7M0peZq78E+KTOMOo0sykSPHnhOpGDOEU
         sQcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793773558; x=1794378358;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Eed9z5suww4/zRV4jVvjzbO04jNWYIPB5y+W3yGdy9E=;
        b=cpdK45nqhANKjthaFwSnKsR3MLrOzJV1ubuS9QoBLs33e6qAL+AZ3luyO83FVfwa2v
         M18lR59d7dZWcXEfmpcRujZ/5x+4lN5inhsPfl48ko2z+Q5XLDiyuR7klRtafJhpPaBX
         1YH4JEW0x8f55abfsmRdS36lamx5ci/bt931XtuJfXScsanT3qIBkX08pFSaSVtAAwOA
         qnKDU74/ZLQVZjWF+S9hNs6Qed7chrcH19vFQQU599mkkJUsywc2byXqJmRKBm/E/iqg
         9oz2kDlAHgNIeYEwR6uaw/z7oLlaMsTPdXHbs/dQs9N/JhtZ/ZolaoN/lUfVv/F6uYZm
         p1zg==
X-Forwarded-Encrypted: i=1; AKwUvBy+wAFovjLCnGIPjh+E3WhCpvSf4qppcjBl3zsnpYacv4Mz4KK2cTUI+4uq1dYRmF1U4aFjGr2oLA==@kvack.org
X-Gm-Message-State: APuU4Z8TX3xLbeVVA1TTkMp+PQF61V1veB6Atx8c+f7nzzui0S/FTz5N
	NJp37b16oc746dD9WUprZKXPPZnFRKKzzlBYi1wLRJZ+bIntPx4WuZyX2lDUhC94eaw=
X-Gm-Gg: AYBFou1H8xOteumyHq0s3/D3cwACD7QKtzcPXfw+k7+G9oMj+oAVRTB27umDZtHam5O
	kFte9VDTF/oc+n2aZtS6ocXjxc7LuoJlqqRImoNbwovck3zL2FrAsd/iIpP03sB4lkWyVXzLRCh
	Nhl8UdR89d8lD6fcCrMvxBdP1kK+Ik14pOsNZvHCZDUTVJFIv/BvUg0Ig2cXiN4Uv3Q94yIYEEH
	gEoXu0OsT4TpeU2hcEQl4h1iN9jkc07vIjNlTWwBaxCFXgsVhycaOCgVlVw0HfcUBHb+lBYJxqB
	SUGMI1iJxbEvUDozNm6FrLU+DvAqrZwAS6sEXmmX2bpw4cX3eu5hE+VCxokDRn0E6eurHCe7YkN
	MgOcyYW/IAtM7tVzECriYi7fmOQ83zfnV4cP5df2bc+4z9XaLN7U1KpTOa4wT0nMCcC3JY72GvJ
	DsmXAftZ/EvItEVhyKZbR85b9kTG5UmMEmY/IKJI+FUiv+Rb9patHrxD0XNQqT2hefJPx6akFcR
	Ha/jBdhO1b8kHS0Njs6IsD1jPUQ/LCSul4p2i+8/MURftcTWASq1ISABM1JnT1D4XrMjY22OLHq
	lY+dDRGn8r8ag4DMDugAum3BBTJh7eWRZUX/4A==
X-Received: by 2002:a17:90a:c886:b0:3ac:80dc:f407 with SMTP id 98e67ed59e1d1-3ae89865dcfmr11962403a91.60.1793773558155;
        Tue, 03 Nov 2026 22:25:58 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F ([61.251.99.240])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b093c499a5sm2672357a91.2.2026.11.03.22.25.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 22:25:57 -0800 (PST)
Date: Wed, 4 Nov 2026 01:25:24 -0500
From: Gregory Price <gourry@gourry.net>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>, linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-team@meta.com, akpm@linux-foundation.org, david@kernel.org,
	ljs@kernel.org, liam@infradead.org, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, kasong@tencent.com,
	qi.zheng@linux.dev, shakeel.butt@linux.dev, baohua@kernel.org,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
	baoquan.he@linux.dev, baolin.wang@linux.alibaba.com,
	rientjes@google.com, rostedt@goodmis.org, mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com, muchun.song@linux.dev,
	osalvador@suse.de, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
	ying.huang@linux.alibaba.com, brendan.jackman@linux.dev,
	hannes@cmpxchg.org, bigeasy@linutronix.de, clrkwllms@kernel.org,
	nathan@kernel.org, ndesaulniers@google.com, morbo@google.com,
	justinstitt@google.com, Bessel.Wang@huawei.com,
	jiang.liu@huawei.com, mgorman@techsingularity.net,
	anshuman.khandual@arm.com, stable@vger.kernel.org
Subject: Re: [PATCH v5 07/12] mm/mmzone: read each zoneref slot once when
 filtering by nodemask
Message-ID: <aurP1MUp8HhhjV75@gourry-fedora-PF4VCD3F>
References: <20261101021340.2251928-1-gourry@gourry.net>
 <20261101021340.2251928-8-gourry@gourry.net>
 <DML8OO28WT5O.3U6NG100XWKZP@nvidia.com>
 <a5270059-e5a7-4c8a-9f04-96135f79ea72@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a5270059-e5a7-4c8a-9f04-96135f79ea72@kernel.org>
X-Stat-Signature: 9ijrhzdtpu713s5yj5whwp46mno49scw
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 57A9620003
X-HE-Tag: 1793773559-98526
X-HE-Meta: U2FsdGVkX1+KXIw6dqufJt5Rw5IgQmsajpzNHE/Rcs2hnoeXUtWc33GXxqOyen8dPa0JGaXibL43shFbUiOeB/6txiORepGGxb65Igg2JbUR2k1VLbrl6UBod0QVqijNF9AZXBXqmnTudiPSzGX85938MAw/7ikVegFrC/cvwwgOh9AVsF8ZLXy4PSGetdKt2niBr9k7Frx2a79HGg6e96w/gbzxpwlj8oNsLc7zMMnBKXD/IByQ78w7Y2IdU83bg/4QYGzZZKhDbILl3hFgJBE3s7ydae1R4KF4D/PdUcuazEnVvBTnk/nQo0c0rpOOo3R1UnmwD78pM+2QZ57nlmX3dlhGvWbQN02+PR8Fnx+qlu51DMgbXe79In7fMzKR9DAc63T49jhrauN2sVIeA2A464Xp27Ht8xfdh40DCOt8XrtYAm97xZsS7PWrDBb+zIydEEyRvKAxLVHFwfW+9THxUO/RdNsmrulKlhs+jV6wN6oZovVqHzv0wQ/CfySOydYCJ8uBzv+ZpEDx5g06k0EkRJYbmo+PYbjAaNRE37bnQjZSyiKbKlMsCymQpOUy8qnobf0ATIUTTsKMBM2kuTayqfaGmUSM85kVJPDVxEfqjXsm75q4C2v8G4lR6eZj6bva/Sw/BLXw1kIGdJCuTOoI0VrotyDeKtwBi41OqlgjzWvlrItS2Q7Vp+U4dXqU+PJ4twEm4Wf3fGzO1s+jWGxizCDOgGr2VPZXQE4LdNDDhMIRLXA+/9nUcNdfb1BHm333zo01tcAoOyXQ2cE8aZ3GlR+Lujicjod14JyKiyc7oZuCTD/DVOONIFCJwpguMwudl4e+4fLwbZ797Nj/IoFz5MqVCF+6hFlYYn9zIuzpH/IgUHer7VWhGhgTNPIlYXGanuj9zw2qC38Ox1nk9UKf33/f2Yxy7XdKqi2w3NhcSVbdgMtyANanJ5FoKoAQzlT1CGAgXy7OpZOsIIV
 3+86z/0e
 VDot6To28FYKrjp89ZpDh0Cfmb91QSS0HR+v+LBNit/rQ1lYvydji1C38rihbwF5NOZxHdwEY2ani7rvY+Ku89yNCoHWc3JQhUVd4rJ0LkCKjXKL0nJg/JSyPTm2kAJcXMLuZZebxg4btA0tB2wWA6wmlOn2X3FcgkIb8Kgs2jHusrn1bWiN+ay6F4HcGMu9Gtf1UwFJ4mGH4WNZ+tpy921YEwOwWO/OgAEmt4ftKDHhi+fXpzuRe7OtyxsyGfHM5VOM0xTciAS697nG/f3m3hqjN2vLJ94pZr3kU5mFtR/nSxJMDAM6ntjjcvyoXH/oqG56D5ujoKssTCh/Lg7ax0QH/2yx4hI0S67bk06XHBKgCWWkL0dgStFkS82FAv/054lkF/8n2xRi/4cv/Y6YtzTvQLg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 03, 2026 at 04:00:45PM +0100, Vlastimil Babka (SUSE) wrote:
> > 
> > It is better to spell out the rename from zref_in_nodemask() to
> > zone_in_nodemask().
> 
> Added:
> 
> To achieve that, rename zref_in_nodemask() to zone_in_nodemask() and
> pass a zone instead of zoneref pointer.
>

ack.  Assuming you don't need me to respin just for that.

~Gregory


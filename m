Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A6BD606A321
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 15:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=x4+05RG+
Received: by kanga.kvack.org (Postfix)
	id BA5406B05B2; Fri, 27 Nov 2026 10:25:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B55FF6B05B3; Fri, 27 Nov 2026 10:25:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A43EE6B05B4; Fri, 27 Nov 2026 10:25:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 778086B05B2
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 10:25:03 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CFCA0A7EDF
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 15:25:02 +0000 (UTC)
X-FDA: 85481272044.15.B3E93C9
Received: from mail-pj2-f7.google.com (mail-pj2-f7.google.com [74.125.227.135])
	by imf30.hostedemail.com (Postfix) with ESMTP id F3E1880010
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 15:25:00 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=x4+05RG+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.227.135 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795793101;
	b=bUtYOZdsT9COgOC8SCVxCH7kku3k/qcUEsaT1GYyoidPvIpUwi8JpMrWuXnjDYDRYkz2aJ
	L4tbVNcwHflb5J6NZnFo62JO0O0VO0HSElzW7mi6NVvK5ENHXc0PNug+kuVUp/w2ifIRom
	fI5AcopCcKJRMA9oViabDlOyVPxRde0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795793101;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vNV24U4AHAf2SEo4W0dYm+4A/c9AQ2fP/eFNSMSTDdc=;
	b=b+ipdB08HCoHpRWYLcuYWP+J+OCQLHj32QuHwLBgmYQD2vxv1i74D9gZi2/vXoVm85aLUT
	vD7PTRRutWIsjurG+KkomzScTZLgac41omNIVJuSBjUgMwTFYjKcbO+h0vqZ8+d/beIuKI
	xlLseBdFyRm1eK6X7+VuTD82CUFy1YU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=x4+05RG+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.227.135 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
Received: by mail-pj2-f7.google.com with SMTP id d9443c01a7336-2f0c72f9a1fso23650435ad.1
        for <linux-mm@kvack.org>; Fri, 27 Nov 2026 07:25:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795793100; x=1796397900; darn=kvack.org;
        h=references:in-reply-to:cc:to:message-id:date:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=vNV24U4AHAf2SEo4W0dYm+4A/c9AQ2fP/eFNSMSTDdc=;
        b=x4+05RG+bvXbDkQ93MYMT9G/K0Q+SZLN0VjXH7sV5hW7XFave62CMIGt+36rG9czAr
         F5i9xNg2CSm6kln2zHCSuchWME4lXAkLq4p9pMs6fy+1l81r1TIiw6LfsbXqExf0rJr+
         +Vu/x491IjeqaabpuBosF9fi8Lxw0q9P8g0LgW1S20XafPuzSsIPow93vpYV5Xf3+gvm
         QL5S4pEhuaEVEljjNJDZ+W8TGzLPJR6Zu8wX3oIlwFhQybfR95o76vOO4KtM8TphKkcR
         3wnTLOBg6zKrbacjGALjQvBxMvr/ZaMLIy8O/3oxeOEOqRpysogEbp6QuD/FbL9G4FOc
         /D9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795793100; x=1796397900;
        h=references:in-reply-to:cc:to:message-id:date:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vNV24U4AHAf2SEo4W0dYm+4A/c9AQ2fP/eFNSMSTDdc=;
        b=v5MrJsYTDtazx3fb5oLeE1a5f/e6s3YXgiJOhd0p393xvjmkGvydF6b08/AXILiQT5
         f7SU4k/QnNHhJidlecSJmfaWu//xZIhBgyqWTEChfTdTeNC+DwDnL41ZXu4zueDa1oYn
         ETm6CzQysOWKo80QJz5+t6CxiYwSQrcqkyMrPhvIFINysrNs3AKz2bt06dKSgY3jr77B
         eGqjS7FP10ZusKT1zJjctQTLZgo96iVyRZ/BKwKrBiwV/tkvxTfm2yc2Ie6Vc8zuo4Ap
         Ojk1YwmuaX691JF8Ay4Hbd2e1cDr27hoOUtDkKt6tk8hBXyDLHPk5vL8WKUklztTmk9B
         vbvg==
X-Forwarded-Encrypted: i=1; AL+hErG7FDFUTuBUYGPl672byK1TJ0N9ZZjSX8ThcdgaVD3WZdlLwMjLcn/KSXJdcpkOwfIdvS19Tcd/AA==@kvack.org
X-Gm-Message-State: APuU4Z/boNMBHGTGQd6d+Q4Q7xG7Fq8m5SAKZ5eNmEywozxHUk0DXjGs
	UxBcFeRsEjCjMWau8JOaxb/JbrTSNAMafbgWA5ZfrSarSbwfjMSvZBWZ
X-Gm-Gg: AZFdTZeZWgdZtkJtnCSFq68YEdvEEUmAaeQ/W4fs30jaI1RDrbuI60ZSsajKR8EqLyg
	82qWW2ZF0YUO6Smako6eMyPgeJhCAdPoXRY+BxeZ6ex88VsISbNKmy90ofaLWQEzaV1soZCP1Jd
	Ej7SZVb60UFQSCx44Z5CP5wPgf7UktNCLV4FrfwCgAcKheWFpWyJ/tTXB3Y/0wYCJKXtp10bxQi
	x3xBsHK3evwb/OTzZ4M528n4p5TFz5wfiXVjGsTMBNw/ptKXc7r7QTVnab+FRCrxeVgxwf84K31
	T/3rxtlNi2lmylqCgBEFU9LTbdXyBtsfWQ2jPWy8ZFMeG+yBqoHgvujl9iyAZddeww7hXp3DVto
	rTQkhQAg6Y4Jj1yIA96p8IAiEQ8dEnAYNk80tIGRVfhwwONMdBnFGvjBN1Mfk2/tQDot7ZUzyQP
	/YXKKVW0NNinmzVB3kSz56gxLjH1basDly7h3/O+2eqh7KbuqC21dfBxnYw6ZzBXTr/fRbfeVmV
	W8ib8Ed8j0T5Z87AYi8QKq6BEymVdgvH8oLnAZiwgKvwwL8g0GRgeeVz4FxuVmfMW2vVddzhxRe
	CTDiYpnG+8aFrSoA/v/ZvMGetI1TDUVzSMHl0Tf4ogpyWPz35l9f9YUfG11IWUdH6xWEyosjYF2
	LJ758sL5JTqB+/D/T7ff1GA==
X-Received: by 2002:a17:903:4b28:b0:2f0:6b8c:deac with SMTP id d9443c01a7336-2f06b8ce10dmr199148285ad.4.1795793098534;
        Fri, 27 Nov 2026 07:24:58 -0800 (PST)
Received: from [192.168.50.20] ([66.90.98.146])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2f03f0c1f2csm123698465ad.22.2026.11.27.07.24.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2026 07:24:57 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] tools/mm: add a drgn script to show HugeTLB
 reservations
From: Aveline Noir <jm5905938@gmail.com>
Date: Sat, 28 Nov 2026 01:01:09 +1100
Message-Id: <179578806997.38.3754686117717776990.b4-reply@b4>
To: Muchun Song <muchun.song@linux.dev>
Cc: Ackerley Tng <ackerleytng@google.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Zhao Li <enderaoelyther@gmail.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Karl Mehltretter <kmehltretter@gmail.com>, 
 "Liam R. Howlett" <liam@infradead.org>, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, Michal Hocko <mhocko@suse.com>, 
 Oscar Salvador <osalvador@suse.de>, Omar Sandoval <osandov@osandov.com>, 
 Mike Rapoport <rppt@kernel.org>, Usama Arif <usama.arif@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, 
 Jinmeng Zhou <zhoujinmeng@bytedance.com>
In-Reply-To: <FDAF27F6-A5D1-4911-BB86-6645272E2BD3@linux.dev>
References: <20261126-hugetlb-resv-drgn-v1-1-345a6ee7c08c@gmail.com>
 <FDAF27F6-A5D1-4911-BB86-6645272E2BD3@linux.dev>
X-Mailer: b4 0.16.0
X-Stat-Signature: 6ko85bg8a5todk1j98z7si8joofe8k7b
X-Rspamd-Queue-Id: F3E1880010
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795793100-19170
X-HE-Meta: U2FsdGVkX1+iXSoGSat2qlarqoOeG3Rmxf1eBInd4hBMmZDSZGZZsV+3sQxivZelWT4DX8zt8C29Qo3kzNo0p36sNt5Ox6er8zk3/sbGsCRWomLARUcVPFMwfrW2D5AwKtwVVmgRPH2SOWHOqLvtRiwtajkJGFK6Liq+SzQKUcTn1OMY9iqeYlwAX2awQKDuLarvfZf5nv7dJmxHgA1f0NfOp9w2KZ8F2Crf7Qmp3rONjlOcyJjdeIj+lH4LTYrAe7AM/I1cDshHdSmHyK9rnNXjA32sRoFigXFjz7U1P0uFwqkR2trFfWTlr9c7hPkGhe2fIDV8v1fEfdZ8SGT/S1SHAuxd8mmXW5/xNnr79daR6kX3M2+RZq1LsbfQKC+znR+ULvM+N6xcyhPUXgMMdDHlswPMXy+GAl8A1zM8SBleKBjCM4OAG9Ydr701PYlTcQB6pE1/bSi+aPNEd/RliUNb+7Sr/8nRDMqII5Q1OnKs3RM1UB8DuzR/+OrWdRYb/CKYBvXFCtlSNkXkiRgbtcW6T5Q/1+CrpiOexQR+1ngLsMvY2OIixtpKdXFhFFtVT1s1FVwS0Q4nwYMeEbwKcKn3D8HoQ7k//xIQS7DcVg1r3rXj4OE5AB0JX9y835wlLhuZAAVK+GGPapG6xZtFWlZO+A1P5nGY8XRja+XbJqRydZIbpXHeJW2J4/xa0SFhza2dor2x098nOpxcELgN0nXOWJIX4zw3VNn5WR/5TtmB/KMreTxg9KrIqh3Ul9ES9L/gAu1u4nVhOoSN/psPBvf1M3Jin2ehT967oi3KEO5Hc7GHl6gpz/oBGoi/QZ5xqdoAC/qK2NsARzeV0pzrLdzlvX2gHY8XqZ72KO4OfoYcHVK7ZLxs105gsdhz8K7Y/HJp2AN/El6fN3GkBmyqP2V2aMhG2Yrkb/suqHXBFnqyi3NMsk8c4PGryN57x1P5on4Txqhr9LJ8NP2958P
 Og6fZ45U
 MhBEWG0QCoIfSjZMegGkwbYJB7n1taDyAix6X0GLTrgIJGRUXp1YAKHBlul1c6EEL2TepayiNKrNo6m370sbNFnHMb1VaSc7AAT4Lkd/MiWfiPhMw3+4ktt0WaTuTEiV0XVWqnGBklIty4x1mawl7wPEkIUu4NEMZ99XVw/PXWFIILwDKz/72xM/cLahOjZ88N9L/egCK15EaU8q1LSd/Y3psCUHfctMVivQmOSoPp8LO69DPHZGTfaCMbT1sXTj+yq1XfHSK/rhyKNcW5FxVA7i3B8FJpapAph7Y2Bgv3mFeaNrguMwChYtHvQwbo7dalkUUDJAb+hyNXFj7O9MNYUr5/pbwNd2UsnJg6cnVY1RC7BIWtwXtVN3lKplkCFqqusse3hsDcXl440a2vnUT4jJC++iB1M8xOM8HaUutJI72Rhww1jPwm1QU7kgsbrBzas82ZJyPQFoROfnMs9HElOBJGQH7U4lXS6Yo57XwtXfmYzqozJkA6yZlXNtNBrLtGl19EZuitpIH1G0vM+tePnP2fSYFwSvq1tvwY/lb/4k8omeVk3qAgfzwsaxmZBh1GU9ihjId2mhZrCpA3ANJVn5BtqM57d+tt1lQGiP5i9knxanZRKTFV4cRpHwYM3yhAA/f
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Muchun,

On Fri, 27 Nov 2026 19:30:04 +0800 Muchun Song wrote:

> The Dragon project itself probably belongs to this type of script? See
> here:
>
>     https://github.com/osandov/drgn/tree/main/scripts

Thanks for the suggestion! There was a similar discussion when
show_page_info.py was proposed for tools/mm/:

https://lore.kernel.org/r/aACaf4_molKromnT@telecaster

That's mainly why I sent it to the kernel tree instead. Having it close
to the code it inspects should make it easier to keep the checks in sync
as HugeTLB reservation accounting changes, so it felt like a better fit
here. What do you think?

Thanks,
Aveline Noir


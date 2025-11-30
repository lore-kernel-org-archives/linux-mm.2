Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F2A5D116E2
	for <linux-mm@archiver.kernel.org>; Sun, 30 Nov 2025 03:13:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62DC46B0008; Sat, 29 Nov 2025 22:13:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 605FF6B000C; Sat, 29 Nov 2025 22:13:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5443E6B000D; Sat, 29 Nov 2025 22:13:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 40F7E6B0008
	for <linux-mm@kvack.org>; Sat, 29 Nov 2025 22:13:18 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D47E78AAA1
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 03:13:17 +0000 (UTC)
X-FDA: 84165802434.15.810CE95
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf04.hostedemail.com (Postfix) with ESMTP id 2506D40012
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 03:13:15 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=cz3VEytU;
	spf=pass (imf04.hostedemail.com: domain of rientjes@google.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764472396;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=MCBBAxlTF2mP5Z0U0RiB6hYPJch5Onp44ekWPHKT/TM=;
	b=Vh6BSWK73Vt0N+oZvVIstz80AlUVrTyNqAxMH6sZmlt1Drlhq+hPzmMZdPbQPq62bDLxcB
	ZR64DuDJUDqaRXa72Ov6HVj/QLP6dQQq4j64hYB1YLQ/YjLqV6UyK0uwlL7sqRxN+Zjdaf
	4gOd5HJZENKFcwpH0kRBZT3BkhHbKRg=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=cz3VEytU;
	spf=pass (imf04.hostedemail.com: domain of rientjes@google.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764472396; a=rsa-sha256;
	cv=none;
	b=nst3tBzTQNB/JSpCahkoxO6wVOJUK3hB3aRmgpbjEm5Ixej9vV+kTLURe5tZRAj6IwLPIe
	N+5Qcy+HuwHLjG4T9lApQ2UO/QYq0GBZ20pMKitcX4QVsNvGVL3VhubIA0oZQRas1qXMQE
	pH/SAuN/dDR+cIgJyfwIVYPEDn4uOng=
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-295c64cb951so551075ad.0
        for <linux-mm@kvack.org>; Sat, 29 Nov 2025 19:13:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764472395; x=1765077195; darn=kvack.org;
        h=mime-version:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=MCBBAxlTF2mP5Z0U0RiB6hYPJch5Onp44ekWPHKT/TM=;
        b=cz3VEytUUe3Ph0b7gue0m1HJCdM8iwbWfku2ySUvMjhlx/m8mD3JGyXa8e5Ygpkj+R
         5ZWCdB5gl4wC3YjGdWU+ushXCKca59RwEPAOgmevRiKkS0dhXd9olUV+vlJagiA6IDax
         Qm1XGXoXB+dAodpNHvPnKPEukvU35de5begn0ffdtSYYQMZPpTEtuVJL5y1ZBbGzvtX0
         goko5MDIYawOknuwLiWaAtnDmVcz//xgjNV4gWrawJmnsF3dMrwhiykQ3lzaDact4ary
         gqzQRwcTTafS4RuhAw0BIIEJRYyBYNV4r90c0D+noaSmkZdnV/ZYaIGHgsj7zHDHbIS0
         lJCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764472395; x=1765077195;
        h=mime-version:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MCBBAxlTF2mP5Z0U0RiB6hYPJch5Onp44ekWPHKT/TM=;
        b=UxX8xOjsmJ/35D/IxIWoNqaSPEz99+xGDRNl653obdRf4+Fq8Nuswi1Cb+ffhFKssA
         KtCN8pO8k5pP8rN8JXM2raNWyZHakk24x8szAiRjnrljIba+QC40C4dhmkxlnH71Npeb
         c8DWCxUFZgDz5CZhkBwNJLEDDqE05JurezNoQS0vv7xafSdRBXbAqe9b/6G3pXDvGUqn
         Ta2vQK4o+wdHq2zOweCuvdkLpA2Zg/LD+S6aCI1d9rvzxhzs2+ijz/vsNdWlQOYFDjFR
         Mf4bGCY/f35qC8UXOmL8KS7LarU+ZF6JL5/NEB+j3TKw47Q3WU26aoyGIKyLFDuRM8Pf
         ktZA==
X-Gm-Message-State: AOJu0YyGbFFjdduK3Iwt/UlmcOf5jbUpKcVGsrNdIJgDOaHhB72zRExl
	C6OM0CaWvDCpUkuDX2HcF+dIPUMxOGGsHL2foJORSh8uSebEaIjZ+nsyfVQI1+NDug==
X-Gm-Gg: ASbGncscGu+YfwVBrj43RM4TUaIVo/XZnIVIBig8XH1yKLjF+7wCwBJUYDqkIqnVA1Y
	BYorbcQdl4byQMIbtQlXETHJeP8e3IMryNFGCgE+Wgzlf5YRlaSJtLK56R9SvC5/yszBLXnshIj
	G1udKvLQCJ9KzqOR3IXGypPMcOL8wzAVDS5RGiXu7jCqVU3LLXa+FaQzPKZvwfqD1zeqP/9Wtu7
	LSUyB17myuwLsHeQMRFtVAj/O2xNnIzjYf2/GbrfyHJUD18q8L8nGpfQ6TEdkv+IF41IW3nkQ1c
	iF/xkkZy2F2VjisRS813fGplLYdg6DhOy0eoR3t6fiE3LjGg4mdxG8yyEAAG7TpvV3/3xlG1OOm
	vnohdlUmW5qyDsZISXQ+YuiSjt0ZIALHXswLy9E6zJsjn1Rk/y30F/Ty6o8VCqsWqQ6EManFUbF
	Qzh5UB+702hLsLwi5J12ahBX1kGJrynksPq6B1J9XNDcdgd52/YNSZ0S1ZysT4cNmMQKh/Ru+PV
	sjH+zSAUYbo1gkowyP/ipb5mAHGctkQ0aD3q7F/4w==
X-Google-Smtp-Source: AGHT+IFgfpSjKCxaZhf994kFnZ8HtKRLMATnNcuNs/sCEnSeCxzSVsaMlNU2QXY8ZnDwZ6McKV65gA==
X-Received: by 2002:a17:902:ea0c:b0:298:3544:aa72 with SMTP id d9443c01a7336-29bca38cdc8mr4716285ad.9.1764472394421;
        Sat, 29 Nov 2025 19:13:14 -0800 (PST)
Received: from [2a00:79e0:2eb0:8:7b08:e467:32c2:1b3e] ([2a00:79e0:2eb0:8:7b08:e467:32c2:1b3e])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7d1520a03a3sm9410054b3a.29.2025.11.29.19.13.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Nov 2025 19:13:12 -0800 (PST)
Date: Sat, 29 Nov 2025 19:13:11 -0800 (PST)
From: David Rientjes <rientjes@google.com>
To: Alexander Graf <graf@amazon.com>, 
    Anthony Yznaga <anthony.yznaga@oracle.com>, 
    David Hildenbrand <david@kernel.org>, David Matlack <dmatlack@google.com>, 
    James Gowans <jgowans@amazon.com>, Jason Gunthorpe <jgg@nvidia.com>, 
    Mike Rapoport <rppt@kernel.org>, 
    Pankaj Gupta <pankaj.gupta.linux@gmail.com>, 
    Pasha Tatashin <tatashin@google.com>, Pratyush Yadav <pratyush@kernel.org>, 
    Praveen Kumar <kpraveen.lkml@gmail.com>, Vipin Sharma <vipinsh@google.com>, 
    Vishal Annapurve <vannapurve@google.com>, 
    "Woodhouse, David" <dwmw@amazon.co.uk>
cc: linux-mm@kvack.org, kexec@lists.infradead.org
Subject: [Hypervisor Live Update] Notes from November 17, 2025
Message-ID: <c08e37c1-d007-b518-f59b-f2d0ebf587e2@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Queue-Id: 2506D40012
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: d6o5f1p3z4bb8x8s4z1bfq6optwzws8q
X-HE-Tag: 1764472395-818506
X-HE-Meta: U2FsdGVkX18iiKsoPyoPphO/77eimwoHP8IO2IEfmx3DXJMk4eERd2WfNWpKIPRnmyMdGFEuoIPnRhBiEzJou/OHx7zhyHEEtYnfzos/JZ+VQFEkpXkm/f0Z0/Sa5naR0bGKnlv3F6wDxVag6Dzc3x1hqxOwZ4QVy84qxLaT3Z2qf/nyNEFF7QEZHmyvjcXrpic7TN/3xOIJsYWot2//MTBp3f5zQvAFQqBCMkwUoTJZPdI0PNZTpAiJOzmVmvgHIWRQ1SnrwWZ6OB24StE+nk77btjdqGtyZ2rmomQI8OMpEZ9spv6LMEdIhw97jVHv3QHWwIM7OuCD0oYSi/kHST+UIEtNKzvV686F5+OUq7AfGrU4ilLN1GbuUpXJX4fdlNRk0gmsbJS44Ye2VWKO8AHigB+f0RfioySLp6O4JZn0bFID0xFJgLfBUfbo+J8Wu8Ay5/tOh4gxnMNa9USIQmL8gfNMKFk8AsaFFphjidHYE3PGwKfzPFmOj8futAWAj/LMFVg1qvEI6nm0RC8SotkGzC2+wEW1SXhwHxNMrivjIjAHuDPAaIF3s3opflnbj+L05Jpe1WwePU6OKLpdv8XnhLxowVV2iGicgGSsgUJktjHjBDoKO7JUawK0GDKVDhxZAA4IBHw24ZxJWEQ4aVmGZAWUlTUxRq8MZckj6zKLbWk7ipsBzPYFLT+tKsGwVI3pVPsb+VLgl4A5fxyrQb1PmjQG5UN/y1o/Ygj12M7bUCJHZadbXDqngnO63JCe5kVdcuDaxZJCDsCTiXHBB/UEGcPp4EKBUanyoDd1gafkR1AoxIgJ/vbNVcC8ZC69YJKusAB86wpcSRdT5QzHds8GXr0g7CRoL+H1t3RVUUnE7mli756fauPySmON/kz5+7dheFI/MQcJgQhMPvhrWP8drWb6aLFM2JOhTgKijeYE2JbblNbhom5wxTJ3SXS/pZyRzeE6RPXh/jTGEv/
 0bhQ9NVk
 jYgvVNbJ1UHnapZvzcaGcEQUfLEboR3UpZZ7kgrAKBrv96deJUXCitHBx30oTydlNPcYF0KnY7nvuFo3Eku2HitC3nZ5wqURGnfCi5AV/ckOWKvm7b66cy5NVJoCYxU6FDXG1ZHfBfrTEsMy7Fc6t0hxwllBVKlRN3/ceRbEGVsqOIllcaG4+EnCKbNOXGzipYHItIeOniRGQ3LBcIzK1gO/v3AFVGnM+KzQuL/sJ3AZL5EOjL0S7W2+X422Jp4BMkOZN2k1gawHbeRmhXTHVRInDLel+nUU6RmVDbYUxyvGMNh9oLWHhsQiQAK5UjrK6bZfJvTKiyD9RLU1nsU1WNiB57jNB7j0nae2Nqw/fQYaJOhoptz8cLhJ7YRI+/1jwzMHgaYs/sKXVc1ThjajzyPbvf260/twS7mSNjoLn1BGMpHw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi everybody,

Here are the notes from the last Hypervisor Live Update call that happened 
on Monday, November 17.  Thanks to everybody who was involved!

These notes are intended to bring people up to speed who could not attend 
the call as well as keep the conversation going in between meetings.

----->o-----
Pasha updated on the status of the stateless KHO RFC: Jason Miu had sent 
an update of the patches but they need to be rebased on top of the latest 
KHO series.  There were some simplification patches that had been sent for 
KHO that changed how the FDT was used.  Thus, the stateless KHO patches 
need to be updated again as well as some splitting of the patches into 
finer grained patches.

LUO v6 was sent the previous weekend.  There were a number of comments 
received for LUO v5 in linux-next that were addressed in v6.  Mike 
Rapoport was going through v6 and provided the most feedback.  Pasha was 
planning on sending a v7 for the next merge window.

----->o-----
David Matlack updated that he was going to be focused this week on the 
VFIO v2 patch series.  His goal was to have it on the mailing list by the 
week of November 24.  The goal was to be able to gather feedback prior to 
LPC and then leverage that conference to discuss the open questions for 
that series.  Sami and David had discussed a minimal patch series for VFIO 
preservation as the next feature that could be merged on top of LUO, 
setting the stage for IOMMU preservation to build on that.

----->o-----
Pratyush updated on his HugeTLB and 1GB page preservation series, he got 
this working internally for v5.  It is not ready to post as an RFC yet, so 
the goal was to have this in a state ready to share over the next two 
weeks.  This will also enable LPC discussions.

----->o-----
Ackerley provided an update on guest memfd support for 1GB HugeTLB pages.  
He has an internal version working.  There is no preservation support for 
it, just guest memfd with 1GB HugeTLB support.  Pratyush had previously 
discussed with Ackerley and felt that the series were really independent 
from each other.  Ackerley was planning his next posting to the mailing 
list after LPC.

----->o-----
Pratyush discussed an idea about versioning for LUO: there will be 
different versions for different components like memfd, IOMMU, etc.  He 
was thinking to have a mechanism to define different versions.  This would 
be supported as an ELF header in the vmlinux.  When you load the next 
kernel in preparation for kexec, luod would read this next vmlinux, see 
what version it supports and determine its compatibility with the 
currently running kernel.

Jason suggested discussing the roadmap for FDT first, he wanted to ensure 
that the dependencies were sorted out fully before doing optimization.  He 
wanted to see more infrastructure to support the versioning and wrote some 
thoughts on this on the mailing list previously.  The ELF versioning could 
just auto-generate out of the aligned design.  Pratyush proposed writing 
an RFC that could be used as the basis for further discussion. 

----->o-----
Next meeting will be on Monday, December 1 at 8am PST (UTC-8), everybody
is welcome: https://meet.google.com/rjn-dmzu-hgq

Topics for the next meeting:

 - update on the status of stateless KHO RFC patches that were being
   rebased on top of the KHO simplification
 - update on the the status of LUO v7 and its potential for merge in the
   next merge window
 - update for the VFIO v2 patch series intended to solicit feedback prior
   to LPC
 - next steps for iommu persistence to build upon the VFIO patch series
   once that is merged
 - status update for HugeTLB + 1GB page preservation support that should
   be ready to send out by the next meeting
 - continued discussion on versioning support for various components for
   luod to negotiate
 - determine plan for December 15 instance of the meeting since it's
   immediately after LPC
 - later, after LPC: update on status of guest_memfd support for 1GB
   HugeTLB pages
 - later: testing methodology to allow downstream consumers to qualify
   that live update works from one version to another
 - later: reducing blackout window during live update, including deferred
   struct page initialization

Please let me know if you'd like to propose additional topics for
discussion, thank you!


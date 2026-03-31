Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82C221061B37
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 11:37:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8AE1E6B008C; Tue, 31 Mar 2026 07:37:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85E7A6B0095; Tue, 31 Mar 2026 07:37:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74D596B0096; Tue, 31 Mar 2026 07:37:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5F9DC6B008C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 07:37:36 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EE05FC3AEC
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 11:37:35 +0000 (UTC)
X-FDA: 84606158070.29.0639913
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf04.hostedemail.com (Postfix) with ESMTP id 2FE1040005
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 11:37:33 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=iDiknAhM;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf04.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774957054;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=uQnRnxiElIBnOUTwhBELkcim5Qz1KuwfRoXgymnyBvw=;
	b=a02dRhJLJ9ffA3aKkvaVF53UBCLwF5GC9yq9b5oafTgYLfexJ1wLLVEfeyEB5kWTib9gFx
	pIfYOOi+SEgnvNLcduaws6UJSjRKS+kcBP2B53p1F1wz8fkRiHe4XucxtKI59mm9OcM9Ww
	h/dzL+BPcx4CAU4hayBQ1aBRBACkxZA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774957054; a=rsa-sha256;
	cv=none;
	b=ugc7Ce7negUWBe3RRiAc+I8peoWQUD25qqLXwsgIxpX1gXOuHuiWm70817VAKTjG4zmPeG
	Q0phq0LzkV+O+GcYCCs2VjvS6royG3/Jbe3OZkwA/mztCG2WSAqVOSee4WoB9/zoZjTFvP
	7DxUEgn4HDr5Pvv9o2C6QQ0AaQ/QHZ0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=iDiknAhM;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf04.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2aae146b604so33053175ad.3
        for <linux-mm@kvack.org>; Tue, 31 Mar 2026 04:37:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1774957051; x=1775561851; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=uQnRnxiElIBnOUTwhBELkcim5Qz1KuwfRoXgymnyBvw=;
        b=iDiknAhM+92AuQsVDfS6SHd35hWFViyImB+ESM++6z6TCPqoAUXHdoM3ic2nvSP7ky
         ClT4m3ZpxZbdhlAmk/ioZb5w+f8l9+2v81ak0A+mR6idcbQcOMJhj6nPkCaSkbzabwwH
         f7SP/YSMeB1dwQ8YQsPXYyzroHnAOkijK3eH/O/udLRdTVbimL3d+cBPPlL/J1xyxUhE
         lwYoBSsMhHBO95rHcVT1bBNJzIcvwnfRLUeA0UrGRWEoev5/aDCTALTlEl5JSHGXeV+v
         eoX9CGwAB6N6VXBhoypspg5me5AxZfm6Y4gpc/F/9qrFAY2RRKKKJ6sSY0HV7tzdVmLE
         NCYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774957051; x=1775561851;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uQnRnxiElIBnOUTwhBELkcim5Qz1KuwfRoXgymnyBvw=;
        b=coOFiAwn+3BO/7YXRGjnoom6M7QXcGytOOf3MSSfp/6fRISrHUPvMOXhRirl2g3r7+
         2TFNYN1ux38DOeRYLGKJlwgsaEIAC4AkLlSQOpdag7utxd6WBsziQb+DMHT3Xa3AKQcC
         MTdrwvvD0TZPqz0Jg6xu2QfZ9t7SuaicluWFxWe7rWhDKXysNrNok8Tc8+lo/smrFNrQ
         n2u92Ahb263+yL4fKS/5LpZccoxdB74K+yezjtAr91lTOiy0YtNJJRrJGvgfgwcvbduE
         ArsCzQpxNIFdzUD/tfTdEi/fYjsudUHZUzylvhE/GX9v7WWx5BwKuVUZXMy4R/aaq7YD
         8LLw==
X-Forwarded-Encrypted: i=1; AJvYcCV9bTOgV7vyM3WLMXok6e2rFPVLtjboUCU/t9mPiv3wwxrq/wWeXPzmpOY9O/IiVc0+Q9VkSZfuig==@kvack.org
X-Gm-Message-State: AOJu0YwskZ5ACP3nl56cuvekmx595B2Ts33Fx9U81wb9Rk/6yGyg/DP/
	0heJHv9/4VD0knWu/eMJUmlrwPvofLIl2PtyAamZodg5N3eW52+yPzjSh01vK7a0ocI=
X-Gm-Gg: ATEYQzw2CP5GUyrrspiGLZLa0cU4jDWsetJIzxafFZsiIlLyEKgELyrWybNYUVa05yJ
	UtdwPlC5dI02rCSffmHw0KwcvGpnLSNOHKWd1z9lvgNUx7tQ16Sq5KCbCeEvw4aRVJt72aAJg32
	KInc0/gutE1wkF2wO0Vh8XNaGCQbyNpoDz0ZUdqhAE6Wsif4bgbClOWyjX6fx+cMuB9+3W/xvET
	RIpmnMwkfnLuEVfs+PLO+AxqPqnAjOxdE6n9jFvs4qwSQ+Z+wFDWgWFOsxl5SxNdG0aXMTFodN/
	tW96FAyfRhP0APPJUnwqzOS2vI4QTg40S10hDrjVYbu1b2oRTmc3DLabdRO7S58ZtFZgiRtOdID
	SmUrmXAq4uQB6wvVEkYyevTNoKO/FEZEKjgArtdd7eVDsVx+Tors/j/gSp1ecgKdXBqJYDz+d+C
	NXFcxXrEMQCk+ZVfLN7BNDdNNm5C5hYz5SD5y6gyE2yGeQkh/w2zy/rnU=
X-Received: by 2002:a17:903:1a8b:b0:2b2:539b:d29d with SMTP id d9443c01a7336-2b2539bd788mr77844165ad.2.1774957051372;
        Tue, 31 Mar 2026 04:37:31 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.100])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b24ddc0afbsm104633845ad.64.2026.03.31.04.37.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2026 04:37:30 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Frank van der Linden <fvdl@google.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	muchun.song@linux.dev,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH] mm/sparse: fix preinited section_mem_map clobbering on failure path
Date: Tue, 31 Mar 2026 19:37:24 +0800
Message-Id: <20260331113724.2080833-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2FE1040005
X-Stat-Signature: mgoztni8chopygys1xkt4np4ghojzoxd
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774957053-126936
X-HE-Meta: U2FsdGVkX1/2psR/+YzGgnnLp2e0FUnxSNWHShz8S7i15YgNZtSLwyaJonBHoDdfVoBiKuP+wQa1s36vmsn49HBKk2xsFTOMhILs34XHmrstaGrQfAHA4lbbAoPPgsWfgzaui2nGYJK+fYws9cfs+iyb/asW/fDbkERaiAZHpzqpYmldoN5kpvj0FIFuKJcAiVvpzWKyK3n0VxJX8fjHZ4KWkWT8/UQILWx1+ZXpcaaqWWt8f976TE5KFfXbDxQDLUtPStmqUDFOpA08vkKf/t5WB+OdPWy99Pc+rYD2LrpD4G1kc9h5R/rODuJ4UJ6jictuTlg3rtopi9PoOMSOO8fdwzCpJYxAl96B9Ck2kYvjl8GQZKJMUbOteds7wWPIQ8bvSBA6wvMroWfDEy8qn7PvuSRizqEoV1Q/3indD2S2zJKdRjZ67ZLEwrVYyD2bqft+ASk8cy8q7s/Pejb1ztKk7oLakP+FU3JnXFBWmQhmXHWsNc+eh2XCii3MEaSp1OwR5WL/v5MekLai+3fDrlbNF0hxFNvnTQS3kDYCYInUa6yIAHfP4ldq6E/KM+VHe5zjrFHspk1cFGN1jM6kRUJYKEHMymV6RL9+bnZZXaPx3JurrtiZD0fqaPflOXhc35n9Nnm6+JITrUxpMVSGvYWlxnKv6MHHMYIiuqEOE1VAdXWYCATgP41qOb+6bOhmlDLf5QJ1Ur3lqRlhFt5kQYZDvgwxpiceu5j6YMNacMl4V2XLJjKt/k6ZqRdiKWjnYzB2pw3hRVe2/2LdhHMJwHfH4x7JeJcAgx6B6T0GCDY5wbLBSH+rL/jizE8A+r7xQaCFTAJ2D+hUTgwW1Jy3wyXgbwsKrTL+4fEh5y3lFBCYMG8Ipfemiiyu4TO1qUlwfaMA++A306Mxb/gag8tuXH+G+qQmhV3jiATcVCDc1PYr/MwpPqT4bfIIk/MNWAQhxw9hJiX4j5TlfPDcPrj
 nDXwrW5W
 GXcEU9xgBVQ5YHMzERXweK1MCrMui/Oi1F2noqrIZ/mNV5JcEp9ukWlY6TREFK6lsXmXSlzwZmfOcnUYszz6eGwN29c+ZSqi8x4Laczkrt9sp0UDNplcRZkOXH73pIyR/LJSu10Q+HUjujNW3+Dio0VNl0MtP82pV6KIsqZ0bgPO/+o9UEa+JG2O9r3pyLcYkiUDSll8IKAcyGGjyhHgCAzWcXjniMQN+gSAs88t4p8LW6qDut03h7W/EqVTvMgfQojtY98sjvAP8MxTby5Yx1EzR9q/MkQWgDtLEWMOfbl5OdcmNWusa9EJKiHBOi+W0ZUTM1Y+iVg1ttEYL5sR/+qDRbrredK5vgZntvaZblvDWWmw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

sparse_init_nid() is careful to leave alone every section whose vmemmap
has already been set up by sparse_vmemmap_init_nid_early(); it only
clears section_mem_map for the rest:

        if (!preinited_vmemmap_section(ms))
                ms->section_mem_map = 0;

A leftover line after that conditional block

        ms->section_mem_map = 0;

was supposed to be deleted but was missed in the failure path, causing the
field to be overwritten for all sections when memory allocation fails,
effectively destroying the pre-initialization check.

Drop the stray assignment so that preinited sections retain their
already valid state.

Fixes: d65917c42373 ("mm/sparse: allow for alternate vmemmap section init at boot")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/sparse.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/mm/sparse.c b/mm/sparse.c
index c2eb36bfb86d..3a14b733bf71 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -584,7 +584,6 @@ static void __init sparse_init_nid(int nid, unsigned long pnum_begin,
 		ms = __nr_to_section(pnum);
 		if (!preinited_vmemmap_section(ms))
 			ms->section_mem_map = 0;
-		ms->section_mem_map = 0;
 	}
 }
 
-- 
2.20.1



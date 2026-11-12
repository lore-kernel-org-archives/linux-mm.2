Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C67D4606A333
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 17:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=bchDkuTM
Received: by kanga.kvack.org (Postfix)
	id CFFF66B05B4; Thu, 12 Nov 2026 12:22:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB0F96B05B6; Thu, 12 Nov 2026 12:22:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA0D06B05B7; Thu, 12 Nov 2026 12:22:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 917FF6B05B4
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 12:22:55 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5D125A82C2
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 17:22:54 +0000 (UTC)
X-FDA: 85427137068.14.6ACCF31
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6C5B140002
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 17:22:52 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=bchDkuTM;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.176 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794504172;
	b=i0slOdHVmbSU2TVea4JavhtYElbKglRVavPb8DRqwotdDnWfKhyH1SJhdZDtTWJz03b5mt
	PX6gSJMn15/TtwvoOUwuqOH0WcHIZHAunQ7K6qMHhDOQxjJMnPK0FaNik/82IPWF/Xrz2e
	bXv2/iBJQ9lhcGEN2UV4LVgqL09BIGM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794504172;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a/JRN/xbf7qsdPvNLlS8GtXasJ+TiojxhhjDTwn3xLY=;
	b=IUIRQ5YArXBZlLHm6NqRu9952lzmTX09qac6tr/t7JIqBVCI3WtAD0uGPxtdQpqg/dMAE/
	k0zlQZlKHQrT+b8Ln3lszO9C36UvVpDv5lXNzsbk1rpXFFjgVspVJrq4yO9fFeTS9FMWK5
	n+PAuhTjC4oLL/pgEA1+nSFI64VfHoQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=bchDkuTM;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.176 as permitted sender) smtp.mailfrom=gourry@gourry.net
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-54f873cbe2aso45031681cf.0
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:22:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1794504171; x=1795108971; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=a/JRN/xbf7qsdPvNLlS8GtXasJ+TiojxhhjDTwn3xLY=;
        b=bchDkuTMACsp7hHtL+627ExstGWe+/yJUugVcwgmIvK7sOnHSTYssECdJHbZuckvwT
         VO3ZJGhz9S9nEzmcEJD9HTVjagl6nwCD1DSg4KSQ2dgI0Ok21Nyl+dSWeXto/Mw+VBVK
         sHbKBqRtT70H1+Q1gVPzJITfn9uy/Pf4HAdg66BgzaXivauNQXh15OCxNLM1cm+Y3E2H
         HZBVzPYMsPoEaMySDkgDx1XV6P3hVQHzffHRWlREX6LBGRun98PN9sGpH8AjR29+PNUM
         QCEY7F7q9TC6DUYzL+OlpYjHsoWA4xY+XtpMX2VG8r1CVFz/GosGK8AF3JSpTwIjNlOE
         WEig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794504171; x=1795108971;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=a/JRN/xbf7qsdPvNLlS8GtXasJ+TiojxhhjDTwn3xLY=;
        b=UHdgPeglO2zUiHTw9ZBH7IVPoG3LK/I/297p5J+z03W2PMafXgODh+p47qvB3n3shv
         a6MJUu69gtPoOHGSbjYxhAkB4kgXssgYayzP8MLp+wtVKPxgOUzpT5/a9RDh9S5vnh/4
         soRLkB3Y8ZP/rxD97jmGyWsTB5vOXdAloodmzetl8RmL0Lg+MlxjhwiRm0tu0062HRKY
         rXZmOoLCq2Wrh6DBJ7EE5O7VBT07yJSxaSlq6IFNJ/1m8mpY5h6Z7q9wHbQ03zyk1EZk
         00/G/LJeFVQBLJXzYQRR4U1NtHdIPDWplnfwxQSvV3Rpj071ju0RbOUfNVgv1nsfLtg5
         OLbA==
X-Forwarded-Encrypted: i=1; AL+hErFycXoFtLo2VcIvpzCYudlj0KDX7WNmrLe2lgjeQ3Pwm8Z/Lag1IfXSfiV+xGQIbms8mNga0V3SLg==@kvack.org
X-Gm-Message-State: APuU4Z+fjbJND91iq0ixKKURZSnb5QkvksLPDiCeKFm0DbjPweolVA+6
	3jgsTIaT1bfksAhhqwVFYiyhxqecLW7k469oGTXY3N1lClOoj0cwKPHyzUOmq+mI9mk=
X-Gm-Gg: AYBFou1z/oyRwyTPMwh+FOTopi5L2loBU9tWMFEOIXBPwCtS0eM180r/IT9uOpZWc3i
	8XnzRendL3CUq2inygxqZy5m8vsMwKeNrKsM2xOekTyHv5qwEBZhQk0pLF0x2B8O+nM9tB59SRi
	zp4lq4sUWKjvMZJR94sjnh4Ft3Lmv3KTnnC+WUvUPRTfvSDcKoca0PqZOHcjz/AZMuMRvvOFqXF
	9c14NO8rGthacXy1a2h6DVDOP+U5vt4RuECHFimxZUz+BSR/Ksub0QY9KpTcrIynvCJOkCta8a2
	hVU3wVru6zafPlKUND5+Ha6815PcQ86H7h2OVotIM4xBUwsGPgcERrxDRgNaW6I8C3DNrb6epi7
	yRhp+uzBvs7FqMepe8xZ/cK+11bSiZeBCmv+64WH/+O/S/ON3QTOEJj6E1YpwI1mtQSBMeGcxSG
	fNsaxvWcgHVEOlihYpsNopPe2zWP7XALQQSX0E3+8L6zN8ClZHujAK9s/9yAKY3skYWYd6j6Qyn
	jnh+k3geGDp3PocPgbyrHf09vP3J6yiCC82/wPKQ1WjBHfX0mrheOAKOkv+rB0gPLS7xdEaSc1A
	gEA4I2JRsL6ks9PxyQ7yqCAs2QSiBVDIQJ9V5eKKgJNKtGBBHKgrKzxwGILApiisNRgQ0kxvKvZ
	sWPfOmVQ=
X-Received: by 2002:a05:622a:180e:b0:536:64a3:aaca with SMTP id d75a77b69052e-55ac8e955b4mr521501cf.62.1794504171329;
        Thu, 12 Nov 2026 09:22:51 -0800 (PST)
Received: from [192.168.50.231] (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91f23d93f10sm542436d6.30.2026.11.12.09.22.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 09:22:50 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 08/13] mm/migrate_device: fix ksmd oops on a migrated
 KSM page
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, David Rientjes <rientjes@google.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Nhat Pham <nphamcs@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Usama Arif <usama.arif@linux.dev>, 
 Kairui Song <kasong@tencent.com>, Balbir Singh <balbirs@nvidia.com>, 
 =?utf-8?q?J=C3=A9r=C3=B4me_Glisse?= <jglisse@redhat.com>, 
 Kiryl Shutsemau <kas@kernel.org>, Yu-cheng Yu <yu-cheng.yu@intel.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, Dennis Zhou <dennis@kernel.org>, 
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
 Peng Fan <peng.fan@nxp.com>, Josef Bacik <jbacik@fb.com>, 
 Chris Mason <mason@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 "Borislav Petkov (AMD)" <bp@alien8.de>, Mark Brown <broonie@kernel.org>, 
 "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>, 
 Rick Edgecombe <rick.p.edgecombe@intel.com>, stable@vger.kernel.org
In-Reply-To: <20261111-mason-migrate-et-al-fixes-v1-8-3d2454362e8d@kernel.org>
References: <20261111-mason-migrate-et-al-fixes-v1-0-3d2454362e8d@kernel.org>
 <20261111-mason-migrate-et-al-fixes-v1-8-3d2454362e8d@kernel.org>
Date: Thu, 12 Nov 2026 12:22:49 -0500
Message-Id: <179450416941.482102.7238369347030508170.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Rspamd-Queue-Id: 6C5B140002
X-Rspamd-Server: rspam12
X-Stat-Signature: r1fd6873c567dhexh4k449fexgarmc87
X-Rspam-User:
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794504172-967693
X-HE-Meta: U2FsdGVkX18JYwfjHqzeVpys8n4GrxWFXqJrVbMoyMkMS/g+Ref74R6WfgW9JUuFkvaBQe+HW3xwmFK5LGvta2DeH7bFPOa1tH071zLuEYC8jAe1xlnn3G/CVXHC/xXdm3Kj9CFgR5pq5xEMN/gW47YkqLbUg4Q8kTZA7Ml79s2AG0WdID5/4iz05y5JsvwFzWOnGe0JQy6d5br1utMPSg68yjyP/2ku1fIIDdygJiWZxVD4NXPeXSBhByGOhsRoZBSKDrvK/PD5kpKSTk1igdteITWiQyWaLIVRXgy+AfqExct9KPDMwSf6FhNU9JDw2021h9ychUFapJVZ4TIRpKtAIjbuRJIJuh4eZP2Kgfbhs+P2dQdTzp4GBUC6xaBWfQezTMbbYJrFG6TaJ6jOeW4ODbBEuuix+kEHF9UPSgjaZcuyl1q/Gg3muU5vGcw1+KbIsN/9iGTYjB8elZlA7SLhoaiaN6uPvHkAJlekjBH0l+7jjDOlsEVW4xqKr1q05WCY78B6ZOms+yVSsRhvlsy1nh41+DMGZjE7A3eMJBHf2zh/zPfMKvz4Yidx1EeNiTKOCbtHHIitZi+xckj64VbBE/9vVHPb6O0POKWTpETQtVPsZD9Ng9/in5327x+qfl/ztuJf9qM6gsecIERii/Z8atnPuufxxPD1QhmPR9GvG4Ysz9tbmnHvXMB7oamuuuMiLu/B9qfCL3IfvSo0/hCcE0tlodcHUDBWXyz64HLFd4sTNfMYtPS65JF7540AO2UB1b476kWIAB6ehYTT+9hxREvC5+pAtFkOfZL1EBvYXVSVE9elYz7zNg0x5zkza+vuVXOpkOX83u0p9RHPOVDODROt5HSVpGTm9Ob/QOYE85GELGjIMs17JYg219YSYXEbjwBjJY/qknCpKOf1ijJcy3vcZlLLRTvOMNW0pJ0L2+TRLGJMAQqvfScBQeR5HZX9ICmh1M+bcQsz0Tg
 o6e4GGpM
 W1MgO/qpslSfCfHZoQeoq/OjLA2eL4ftssv8OeuP54M7XHRckZsU21mktvfSZrgpuHeyJzwM+JnsIdsX6AIo8m+0XshTDV19TuZWiLZnnrGo4D2Q/SqXTFzaRvj9/4ka776hVRyUdamlgJEc9xHFEIQfK7l5SjUxXmLiqAOup8AZW7mshLu2FarSSalR62CNMVbOCoJiAhI3N1dTsfa6VmhM8ApisWcQa7lS4Nwqzfks6Q7t2SEQMFl8Wmdp853MV6Gs3vr77RuSTGb5pcFQ+VE9tF+hVIkmJFOLChWGAOzoVHHuWLTbixP9eN1fotmdYLkqUP80LCg4BOttEkU2myV64NzcQaRV9mvt4gvvdKvhp3/4tOh0Yb648MpNg2m2AP4b9xZflYhOge+KmTVd0tiQil7J5agiz6yea40A3nZjtTE2Yg0B98YCF8dVa3vlxVgbkAlrtdlX7XzpzryBorLfUNc1ubBdu1RxqPjcNSvv4RmSE/tUksMBb+Z+eMbEbT+5sy1dgTjPDLVmP5fwauK7VSD3P4H8nNxExHI5NLR8RvkYqF2NZvGPnTTH9dDFSMTXJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-11 18:13 +0000, Lorenzo Stoakes (ARM) wrote:
> From: Chris Mason <mason@kernel.org>
> 
> After a KSM page is migrated to device private memory, ksmd can oops,
> and KSM then stops until reboot. A process that maps the page can also
> loop in page faults when it next accesses the page.
> 
> The problem arises because KSM doesn't know not to try to look at device
> private memory that does not exist in the direct map.
> 
> Disallow this from happening by explicitly testing for this scenario in
> __migrate_device_pages().
> 
> Fixes: a5430dda8a3a ("mm/migrate: support un-addressable ZONE_DEVICE page in migration")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Chris Mason <mason@kernel.org>
> [ ljs: tweak commit message, comment ]
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reproduced and tested the fix.  I validated in the base kernel that
a migration could succeed and after this patch it cannot.

Tested-by: Gregory Price (Meta) <gourry@gourry.net>

-- 
~Gregory



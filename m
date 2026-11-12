Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D71A0606A883
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 16:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=R3gU4r/E
Received: by kanga.kvack.org (Postfix)
	id 02D426B05B8; Thu, 12 Nov 2026 11:59:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1FCD6B05BE; Thu, 12 Nov 2026 11:59:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0F5F6B05BF; Thu, 12 Nov 2026 11:59:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BBB436B05B8
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:59:56 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1D8D51C3478
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 16:59:56 +0000 (UTC)
X-FDA: 85427079192.07.4CD8580
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id 2860DC000B
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 16:59:54 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="R3gU4r/E";
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.172 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794502794;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b7AojsWQdmnu8z7CsRmtwQ/iZVkZjTk5+I2/AfHY1s0=;
	b=5f8N9Grr4aX4SK5JHy73o1/xUEWbKrIXLt0NJu84q7QNz9NpLHqTZRue+KgsM2/Gse2SYF
	86hosj0R4XnraO12rUMNEjGDKhRdZG7RYpQBD0vRkxSmv0PAZ3RnEBquNXuMa2tlsuiv+E
	oCsUit2LBdufO4DYkV1JNpTcVcgUBXc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="R3gU4r/E";
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.172 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794502794;
	b=fwy/qjfxN/RDmdgtZ5rgbkpb7Dx8xLKs+/jlWKE74ct2gMzxL4h1ptmL+yYVnmOgudu2VF
	AZOCDf6u7rixHwb/93/tPW8n4irDOFeMJ02sa45IpWHz+8VPxFie2MVUlaad4kSRGA868Y
	1wvXZsi2aeJDp0xcr5XuFHythSHYgDg=
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-93a40a9a01aso142303485a.0
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 08:59:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1794502793; x=1795107593; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=b7AojsWQdmnu8z7CsRmtwQ/iZVkZjTk5+I2/AfHY1s0=;
        b=R3gU4r/EnuDtdz3ackHA94qB1bsh45HIUfwBmo1sfNeaZkeNY0afKBlHekSBYKPvnJ
         sCFsl15baILC1dY1GXl29NBPOGuaBdG7jyi6wuN5AUYqmwJmtQAOZ9Tz5CEMyg1JBWBI
         1yqI4M01qfhAKXpKQDQYLUiJ6BLY+QcH6U3+cyta8HMmGtyF46gx8w/lVnUYdXNx8MK4
         cwhb9JEsqRkRZEqYxaXKzhve7F3HZSLK36NA1MxkOeh6LDHm8+XOyqJWDiXpVRs+vqQT
         eauc7eQYtjAElPl5TbKMW7MKalxXCwWPyhSD371LZbhOeDCf2nILtkDTXGA9JyNNcuEn
         wtdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794502793; x=1795107593;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=b7AojsWQdmnu8z7CsRmtwQ/iZVkZjTk5+I2/AfHY1s0=;
        b=UP8XCNa8VYrcxNP3CdFo7iD1CHB80T6P3mhWC3y1ALU4iiJnQS1iLYr8/ndniGMlmv
         SiBmyl7f+qoIYZb8GujPhxBNrJFi7i8ZgrtbM6697S5m8zNfsTob6Y8qYj9Nm/glsMMW
         TTHuSoCC9Nq4UDGHDjcTc1hQ3K4BF+irl7OxU5tw6B4Lm4j/ED7n/mpBgYMMkqShQ97t
         Y8NMjEuFyel5KmirT4HF76B8dw1Mi5PIn0kIpdJrr3tOi6SpguBgwzh+B7NsmziATFER
         EWTSapY8e+j5iYfTDHDAUQCdMeg7jqALfjqwZACYOY92Z+RTzold9iy6txr5MCTOj3um
         ooPQ==
X-Forwarded-Encrypted: i=1; AL+hErG6uTHO1Ws6eshh4dmdOyuj/QF8IR4osxFgw/hzlm6MZDySw8RDWm+7j0OzJAJs2n/IDB1vg0fz3A==@kvack.org
X-Gm-Message-State: APuU4Z+flVhn53L6ZndU23Jed7Fn5SM//1Rz02/m/f/P0s5niQegeKqV
	89BxC9Yz6iohvPx/LuszZldv12+emLjr2YL/nWiXeTvxm2Kmddk0i/dqDfUO2oymK9g=
X-Gm-Gg: AYBFou0rDbMWliRP7ziZh682gKsbTjM4Vaw6rw8wUnFHrzzPYE16wFX2j/iUI2D5Wwe
	fa40hXzEXjtIpT4YajGzldbXfri98pg4aqzW1HAsjI5PVEso75WOvyslw+rAs6RbiKJhV8SNpsr
	3pABAD9XsUuG57sEO8RLO+lDQPGmvhjiw/XhhmEkHH2THK0H0f7dkI+9zAgAVcQIQNSgyzf7f+W
	94k8Z73dADH78r4cfelmaocRHf/7HRCYif13tAfYmLeJhdiAs/ieak69ImMnEcyZLjUDqEtibzx
	ksXLv6JB2aoXqj2/bC3uQJ+yWzWITaPY1yNju3ajSJWTEuG17INmJAECJiyVnE0qQEkNzmJmIcu
	oWv1IVuZ2okiSEj14B7sCKD8zKZ53gnv2d+KQq333PV3S3w+cI7fVLXynjQjx8gcePE7oR8KrV/
	toavx3D/O1CQ40ffpxBmAoq/1w7becwNH5biObPmfJfzBK312IXBShCS2XAMXDBvd9mdFvlt8W1
	9D3/M6r3ysOxs6VX9HNYzJ8rOz15r3c3M48uBX8KX5meBAJnzIbu61SEP98cKnxa2N2IjKx/vI6
	+pwSRuZQI6T4ynRBLJbx6JSQnXDpeu27vDjvUW+CM7zFMT6suqSOoiq639o3sCrBgHw20e1iUlj
	dojTPicQ=
X-Received: by 2002:a05:620a:6088:b0:945:f5c0:a630 with SMTP id af79cd13be357-94932e8795amr549937885a.40.1794502793241;
        Thu, 12 Nov 2026 08:59:53 -0800 (PST)
Received: from [192.168.50.231] (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-94935073633sm220651485a.37.2026.11.12.08.59.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 08:59:52 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 01/13] mm/mmap: free gathered pages before MMF_OOM_SKIP
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
In-Reply-To: <20261111-mason-migrate-et-al-fixes-v1-1-3d2454362e8d@kernel.org>
References: <20261111-mason-migrate-et-al-fixes-v1-0-3d2454362e8d@kernel.org>
 <20261111-mason-migrate-et-al-fixes-v1-1-3d2454362e8d@kernel.org>
Date: Thu, 12 Nov 2026 11:59:50 -0500
Message-Id: <179450279073.482102.1691484916250559829.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2860DC000B
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: m7zuwwgtr91qdrusu777g11wwsbrut9a
X-HE-Tag: 1794502794-987281
X-HE-Meta: U2FsdGVkX1/ivLBm6sIGz+O93HpJPorDbZYRbpawPt2zhdYRZAg/fUTdlDINMfprBl6pYceJZJ3jCopLgHgI/Phm+zIdgDPv5b1DOc+S9PecE6nBuFFkImxPW1WNhTMIHjebN1G1OeExU2PSYWS4SasdCkLl8doc1ZAKqcS3t57YQ482JBMfwo2T/D0sMXNCM7tf+w5oaK2lVwsavC2JZMrdBWKjZ5oxs6LT+RAImK8Zx3FCmrXe75OiKeqZpekKTRzPLyC5uPC+lno0VoQa0MloewmswIibF1bHxGLBfMGM1MdnxfmTQZ5p6kuAkq9Tq0Ks3LsdLhMR5FD6/3gMIaJWrJgtAjupJcbMqeuW0IfdvRT6mWyYSxrJqqFMNWbxIhXvuQj7Xi8xvrHvLk2QHxpbfvNLCxsrlp8UejtM0VvYl4oNpVGnWA3BYtlMhIp3M1BxdLbMpPoYY08iEcclvWIcE5G5LUawy/5NmT61SQSS9h7umFcM1UR8ZRPDtAMq2Z98GATc6G3dql0xwjQPyUUYaxd1yobwXCFEORYo2goUL+A0P85IKzGG61Or7OoWpShtNY/GXxHW8DaEten3fRRFISA8nnQ03fSzGlyEzqGX/8DDUsaTCmZpJK2ZvXbcfQNLSDsDD7xJmqEtdbGXjpziVrWpRJ1geLJA7Mai4SKcYuAu7qV/vSJ5eFjSlYMcPgjrqrOCpDKPnDB5p/3lGhnOyeDUpTievQpZ3jv5Lk5bJJr4UVVS4HjUV5JvGYyTf6fSM23Cb6F3oGJVH6VDVD75vJdAlnbup30BPVSEGm2QnZTszjwmSXY9BrIQ+mI5rmYhW6seUkNPwsaEYgLjr0OcxYXMhDjT/YA5brmoswTdznBNe1XkRWk9r4xoudTmC3KwAjApOzoNEbedy+zFyE7Db44cC+NWICUYZvtJRYj5WoVyP4KT9NV5WOQj6ztP7ZehHd1hyl5q1KTXbLW
 HQRBbygo
 FrEREiZ5voviBVVqN8j6Og5ckuBNaWRfc6ocdU2LBwqREwDs9UR5bx8P8wQ1gQtuLD35DFypc6UjupOVwtODbJh6s8Jp73b1FLQzQO6UZxj89Wn6u6lyujRco42GYcSTqyLsw4xN74Lkze6dh0u4T7sPfATFShtG28b0acFw/6gYfXQ58fiTW2aYztGdjAIhLD6C5k/3/6FbKo6U/iQizmzkWX3KFng639fT5u+rhuNro+cSJnRplES18WsjpGr0I3r/7L71gZTIExa2g7lqed2CNS9ZUg539TCHTRy2aVN4kBsDTLt/uiV/X4vOpfVwfsfbxjN5excbSWj00LQeULx7bRu2Qwdd65sru/D6MlUCUpxpz69d2LihXhVHuBZhQLnmslBViKaeTAisKQhngZtmi6e66J1hiJpLh+370CXtPXcFJ8FE9V7L4IEveEecFeCB888Mw3sXlFxA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-11 18:13 +0000, Lorenzo Stoakes (ARM) wrote:
> The OOM killer can quickly trigger again after having selected a
> victim. That victim might not have freed its memory yet, but its mm will
> be marked MMF_OOM_SKIP by this point, so the OOM killer will ignore it.
> 
> This can cause the OOM killer to kill an innocent process when the first
> might have freed enough memory to relieve the memory pressure.
> 
> Fix the issue by freeing the memory before marking the mm MMF_OOM_SKIP.
> 
> Note that the task which calls mmput() might not be the victim - if it
> took a reference on the mm (e.g. ptrace), it may hold the last reference
> and release it when it calls mmput().
> 
> Therefore we cannot rely on current to tell whether the mm belongs to an
> OOM victim. Instead, partially revert commit b3541d912a84 ("mm: delete
> unused MMF_OOM_VICTIM flag") to reinstate MMF_OOM_VICTIM, which
> mark_oom_victim() sets on the victim's mm, and check that.
> 
> Reported-by: Chris Mason <mason@kernel.org>
> Fixes: bf3980c85212 ("mm: drop oom code from exit_mmap")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

I was able to reproduce/observe the unfreed batch and the second victim
issue.  In the base series i could kill a second victim with the
in-flight oom in about 26/512 attempts, and 0/512 attempts with this
patch.

Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>

-- 
~Gregory



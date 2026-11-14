Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2ECB606A8A6
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 19:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=YAGaK2oA
Received: by kanga.kvack.org (Postfix)
	id B7E1B6B05B3; Sat, 14 Nov 2026 14:56:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2DD56B05B4; Sat, 14 Nov 2026 14:56:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A446A6B05B5; Sat, 14 Nov 2026 14:56:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 738636B05B3
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 14:56:44 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DA151140441
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 19:56:43 +0000 (UTC)
X-FDA: 85434782286.27.3D73142
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	by imf14.hostedemail.com (Postfix) with ESMTP id EC8E9100003
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 19:56:41 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=YAGaK2oA;
	spf=pass (imf14.hostedemail.com: domain of chris@chrisdown.name designates 209.85.216.42 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794686202;
	b=7E5yzmmRewrn/oOuxzCT5rU4Wlo1RXYCJyhb5Tg3Adrn/N4zsFBbVtHdDfucbkYf2izul/
	8Mf6/NeyGIV8RsjD0o5vl9EPz6PlIYS2n2ug2SKpA+8ddHP8Swk/gLIeAZgtYxi1bA9zLH
	EaQr0OT+BkiGYalofZdw2slxliBqpiU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=YAGaK2oA;
	spf=pass (imf14.hostedemail.com: domain of chris@chrisdown.name designates 209.85.216.42 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794686202;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hrbRKPtAWBgGhGonvqRjGeinfUOoIFn0EQDX8I3HUjg=;
	b=h8zigRUBVcYmEJQUH8F4TvYQMsHTekwtXLrHIm+gbkFKwHIrNQ2xUD2ivSC4HVpx+HuQR2
	LHkF/rs9tlvPUBrAZOV4KeMNK+IlmO0xVFCs/UUVY2/qAqaX31cdetIGidGrvT6PDdElW8
	4opmwZClljccx1W4yDyE7P2YYYvJVb0=
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-3b197cd42b0so1655787a91.2
        for <linux-mm@kvack.org>; Sat, 14 Nov 2026 11:56:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794686201; x=1795291001; darn=kvack.org;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=hrbRKPtAWBgGhGonvqRjGeinfUOoIFn0EQDX8I3HUjg=;
        b=YAGaK2oAm6GJoYLYBfs2X2moZh+Zr89olzkj1TxHtTETwvWt1fq5ON7j8LEP3a4ruU
         xpegOarmeRYxVHy+vV6mKmCMT205DElJquk6gwy2KIYv5N8373edOTOcNYvC8GxltmK1
         mWfM0qBI7uaKaUygta2jh7ekfK7pp+FMs6zLA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794686201; x=1795291001;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hrbRKPtAWBgGhGonvqRjGeinfUOoIFn0EQDX8I3HUjg=;
        b=dbnjEP9JQOMNrGWUQkdfAvY6BshjnmimpOv9/SMy7tJ4uYGC3Ddz0Gc6C7xKw+mCGa
         4LlMo5wCnipzhxf/01T9hZFOE+3WDcr1nHN82Iq35I4Sux0WsE4zocSMkvFRlDZSGxK6
         d2p8MW9691cAp4NoT4KgPxq3JczK4ffFIa0jLDXMKnBz4WgjnxaOvnVHOpkWvQ8/azXH
         wuLEw1R+SHRNmGKuVmCRNU+nKe+oASzZOXircCjZERpP3dCfhvc8OMpMyjfK+L0Z2pAw
         epzkwm11MBGPHudb8BPg1Phkm26gZd+udZyDd3N92N2WoU3qEUGQJE371g1BS0QxOekl
         MWsw==
X-Forwarded-Encrypted: i=1; AL+hErF4O13Z0MLllpdWzuRwCISMy18zTabBUuhKZLXlFmbU739z3iw5L3AT2HgFD3liWDD/NHFBnPZ4BA==@kvack.org
X-Gm-Message-State: APuU4Z/soDMxd1R03HpusPuokmCDWNWNo4RywWKcn3RVnCg1BEXM2+Ts
	4NFl7sHKyzbdLNhADbZTlEhpkzMvB3Nbo5ZKp6ZHDbpg08OjVg1eaSMxC2ZCCI2LWz0=
X-Gm-Gg: AYBFou1bYm6B/ReFHFyvFI6vPp43uX88LLXifObFTS9Xkf/JYdrNmjP7uOo3wQksUk3
	Fqo6AFWJ033MumjoZsaWEk2REybt6DALSSLDVDG4nPMGbGdaQz42MuszGp2CbBk4v3/hIRJiMbA
	/5juAvFGtYSI5CS5J2iFXw6yH3O4H5cyNAZLX7aMsO8I3Mp80xwC2cLlWMsnFlsuOHRu1CuqML6
	0L9XKkxej7R12ol9ZgzB5iL+f1sqmC0Ncu1HoS1r2rzBlAIjD7qCpsYfNZCRMp5ehGD6gojtCFX
	R0eRcdybjzb9xTQFfAQqkv559JiXUMyD6hg168675I/zyLE9YTWWzau2iINKc5poLJ4XMD16eYE
	2w57kRJoxuffCwX4u0ruBcehn2VLsbyoYLq4x0yekDC/VbQh3HkeXRrF0Daa07r2b3f9LBD5vCx
	sb+iTlB3s5cbbaTqp+/2InfoqcKBi8nKTcYLjL677xXt9NeZXqpG/59RUfhiP/7gZehzYL0kcEi
	qQ6//Q0hKu27hjIoDkuFm1YAaOyYY/ZfjWwdxV19tmC6UllY4MVcTXKUEWPHkkGr4NFDVLNQVht
	hGz55LAhA6S/eKirtcTbc8zGce3nb/Ejd7gsdxDpVF1H0kC2YUlHWLeiV2G+vNy/pwb42VncHn9
	UePHMU6Y84Y3di9cR4Naevfg18TsY4Dfwb6SLsmimU0zsGLcpNdc7eJPp1lOJ8smukylIoeZIBk
	Xi1Z9AUmvn11QlQ7Oot+f5G4FZbjESJNUXapoIaho7ICBfZJ9cYbakeeOi
X-Received: by 2002:a17:90b:2e06:b0:3ac:8897:7bab with SMTP id 98e67ed59e1d1-3b1b07e1cd4mr5830748a91.6.1794686200819;
        Sat, 14 Nov 2026 11:56:40 -0800 (PST)
Received: from [172.22.0.2] ([64.16.22.130])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b1aec63b9bsm10008894a91.12.2026.11.14.11.56.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2026 11:56:38 -0800 (PST)
Date: Sat, 14 Nov 2026 11:56:35 -0800
From: Chris Down <chris@chrisdown.name>
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
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>, Usama Arif <usama.arif@linux.dev>,
	Kairui Song <kasong@tencent.com>, Balbir Singh <balbirs@nvidia.com>,
	=?utf-8?b?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
	Kiryl Shutsemau <kas@kernel.org>, Yu-cheng Yu <yu-cheng.yu@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>, Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
	Peng Fan <peng.fan@nxp.com>, Josef Bacik <jbacik@fb.com>,
	Chris Mason <mason@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	"Borislav Petkov (AMD)" <bp@alien8.de>, Mark Brown <broonie@kernel.org>,
	"Dennis Zhou (Facebook)" <dennisszhou@gmail.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2 02/13] mm: cachestat: count each page only once
In-Reply-To: <20261113-mason-migrate-et-al-fixes-v2-2-50a2ed382b61@kernel.org>
References: <20261113-mason-migrate-et-al-fixes-v2-0-50a2ed382b61@kernel.org>
	<20261113-mason-migrate-et-al-fixes-v2-2-50a2ed382b61@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Message-ID: <20261114115635.8346206195d50372@chrisdown.name>
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)
X-Stat-Signature: 91dq7mkrwfwt5hoojdogazbjb6zgii3x
X-Rspamd-Queue-Id: EC8E9100003
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794686201-833218
X-HE-Meta: U2FsdGVkX18Ll6UGyByYY2p++5Udvgw+8L9Dsv0ZuWSvMHnrZUhfFWuYS4ofujsCicS74sOgL9aF5U+j6FP/GfZfCbWANJkiXoeL8BxyznuaYKDXAbre0f3i7wcmoOicrvh3IfB3R0qTNP96S8GOOTUSn0BL/BtM/2w+LUH4yImjTU8XiJOkXf7ACAcULXJZqYAYsJqy0eGUh+YlmzvElw0twbF9d/eNjq/Hn7sFkhShA+mjJTyUHj24k0k4Ff+UpRIGPIrfVWwN3lSPEZH4aFHcuPNESEzyfaQHU/lXnKfvoBJ9OPbSGDufemk4Fx9nCfGqJMos5Pr/sZ1KYUftv/NxvQKbEERmSaR1l+lhJSqI41G8joeS/G7HxiWlvCZfcNc9NTPB/lWssX1PDAb2ALCyYWnPpgPLH3lklYe5TJx1OuUSHGW5SqigBOu3hjXIXdc2hlxOqPYzg80BpJMsuZ3EgVCVRYO3fumiaObL0DXlshXvHjG2aUJ06uVx7peKcmQKO3YIARj+dTJp2RU7VO40PTmjLfx/Qi2PGY8QSyXpx0xda19Sr48oRDYmYo5ppsi71co7nHQQ0mTZosaZXWYqGM6DfGdQUaY4Uuo+Zu9ACbn5QuCOnY/ddDOKqoaVxcFbolfn8uxfZzun6f0gELVnvFPF7jPzyKw7/JLJ8hVNLbncQeEnP5X/gjfE7Ngc8ewavKF21iBYwney7mZ4LntiqAs2dwlaB7aB33KmgQC7YoCVwhCNhcmS5WYCdB/Phqb6MNWlkAJ0bBdFOnDnxSBIoZUFtx4x/kbUhW1lcfzw2pWcVWQCvAO3XM+UO3G1Gu7Y1+cM2PKVt34js0PC0CVoQ4EuJEImSr0N3XM7KL/LsnFsfVBTvIK+DLQ4ofQSYrMsPof9H8Cfjy7iVYdKo+tQulCgqvxPfMCMWL3lw//6fmvNK99VPc7qrhoR/8PhnofNpIcWcXc5RpYTUZJ
 oOOY0R6p
 uuFmqld7yr4RN54XbWA3a4Ey8xkgheYVGLUkVFxkX3bmsDjN7KAhMr2I31KugN9pzKbyuZuYGASvYfW7X7BlZSdHTIYZLlWClqZx+N+WVqrE2lIuqgKKelPrvLPkxTFA+UlTw/RwrNNKiCF0ZVCrzpF7qzN5odxpuJ6eZez76wEMfkhyDtQD7NPwrPxf3eBqkAwon2Jvv7Y9VOW1gjHRbMb4C63DCkriFXAdwxsvIiOxLfmnNyYdoFJytunwg56DCM6CsJpnJVvH65iJldukzHZc/VyT2wQt7Mg4TIYKGx4zQYchZfsvNoUiEAFO8w40QG5lNu2xzUjcz6bXQ1FpRqqsGtfIWprOgsh2H2jQfXgVHZ5n9vyFcmGxSwkSEnAwSMnxmJqFxMZEMSNp8q5TOjcyHwoiWobEeLga7tSH8yShhQO15JXNhk2tkQ6THUv1PE7zHkDA8JFZJmk+B7PnMPW/pazw2ERWSJ8uGYpa0NQNqD0qR4b9BkThS3eHggsniFb4/DxAGZjQe/04miio3q1ZsfpkHux0BJMoq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Lorenzo,

Thanks! I've tested this with cachestat() racing against splits and
collapses of a tmpfs file, and the counts no longer come out too high.

Reviewed-by: Chris Down <chris@chrisdown.name>
Tested-by: Chris Down <chris@chrisdown.name>

Chris


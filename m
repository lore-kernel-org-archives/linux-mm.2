Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17C52606A882
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 17:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=Z90k8q+A
Received: by kanga.kvack.org (Postfix)
	id 3A3D76B05B2; Thu, 12 Nov 2026 12:15:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37B476B05B5; Thu, 12 Nov 2026 12:15:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 291C66B05B6; Thu, 12 Nov 2026 12:15:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0A2B06B05B2
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 12:15:06 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 95BD016061F
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 17:15:05 +0000 (UTC)
X-FDA: 85427117370.08.8E95BE0
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf24.hostedemail.com (Postfix) with ESMTP id A02E4180007
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 17:15:03 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Z90k8q+A;
	spf=pass (imf24.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.179 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794503703;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pkUNJy/G/i2yr1NWN9oiSB6swWvpLvuFtnABa0SM57s=;
	b=iKm6NJTHyRNqNNL8AcPeePfVSO3FoL/xMRrIpho81T0T5+7lP/t82s4ORGy85mIJCY2twk
	Cv5EomMZJmLcWxrF5BiS169CTg7SnUbvl/o7ZvNmF7qDgsZq8cJi3IjUoDthjXuSpEezx3
	gYyM7IKj50iyFwjM9L9szPd3IXTRsmE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794503703;
	b=sNKXpMeFu5p2snAQn04nv19nB1Ly3VuqDPgvylRzeces0DxEfXZtkZNFdkpNi7LzIrfcLX
	cQ80WNsRXgFAVfwvHsbz9NtKqbInpXFEQMlxatyA2L/OHPOUs66PdlekXMptR7qKZJklu8
	nho521VpJZu8NoJdKs0goccWyv6FZLo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Z90k8q+A;
	spf=pass (imf24.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.179 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-53669f7b518so45421831cf.2
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:15:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1794503703; x=1795108503; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=pkUNJy/G/i2yr1NWN9oiSB6swWvpLvuFtnABa0SM57s=;
        b=Z90k8q+AvK7vpXVInimm6YdyyXnOQMwtRsX6qHAgysX0wH9BI6Kcjwl+O16zCbtZxp
         ocIkSWRt9FDP+zyWci6Wh3leCytSzYGK/VTL7/vGM/MZxs4Wd7ioZ32bpUY+G367nnqt
         BXfS+Nqz/afsDeoFmYVhP4IrnzM3G+cehgw3Ee1LQyTlO+NiYJha+2NSndUtBKefLqI4
         vkk3Z2VHods3fAlamHIm4Rae8escZjbB39cPbEME5jGeVPEcGW0sO7FnD2hZzUdhUJna
         AXyROIrEKdm+FMIhJLjMGWXXnNA5HmSdJWCGlWV4zZTxUvi5ZnkMkI9eNcf2o5NalauI
         VWPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794503703; x=1795108503;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pkUNJy/G/i2yr1NWN9oiSB6swWvpLvuFtnABa0SM57s=;
        b=T4YbHAyTMrgXQutPY9eopN7hmpbi+h0tIeU95jjeIDaQ0vPt/sQGAXeDZWaQ00sWr1
         E2fTQq+EUUrv2L/9CfGweXrWEFxlY524FQyHD+574UG4ar7ZCubG1wM0yIFDq9fAYVch
         mOqC3MmIgsOvhRXVTcYrvjNVdsN06H3srYfaybOoX9wZSni1iL0Vi+vAAf/5734zGbZF
         IwF0rpXbXEk066JKAP4WlzeXusTU9Sxu+QPG1KDkGvjLJcoV8taBasFQt4nCfYnyQ8Qv
         mSyUbK5HtEnNrqxSGMfE+ukKn3u/GRawTQyBVdslf7/aDkIWrFrUbgG/7LWd6LYz3QqQ
         4usQ==
X-Forwarded-Encrypted: i=1; AL+hErF1IjMwJ3/P63Iik1xDutikrUFEK29UxsIsmpItGZY3wjfU9+3cOIkUCH01dwUxuBhFYjymHaS4Tw==@kvack.org
X-Gm-Message-State: APuU4Z9UbawkHDBzQYtZ4CDMtBOTsDwAt9JIN2cTf1LBeMKrAs2WYkdO
	PkijVWV30TiNHR+iLzTet2qx5wPenN55NWlQnoCxMGpv/r0BKjc+zvzWF+lh+67GOVs=
X-Gm-Gg: AYBFou0FqLn4jKYt4V9mvlcueCUU8ib5IhQbFiYsugZWFkS+QiUGbVqKN8iwv2SD+O2
	kjD3D9ChldVfbDWBu52r4Ab1vbOsnaB4rfKq8QVRPESpOjq2KZ8wRS3zl+TsFD5WUz/CP+5q9cb
	XWhwtdqZqZEf33JZE4qX9XRLULBugViqkGEEGs1dJ2OveXDERAnHW7vtqQ0A9XYcYPuo3Y4B0FD
	bWQtlT/Z5KJVxcUgzLbU/X3eBhdYAfctqoeeUKx1o0Ovmv48SQ4QAy1jsLEW1Vze54ZE7ok+aAD
	iKwxRljEzogZQDoC78T/cGkJX/o5SAyGxVA2Av3dD0+ZXL0iF9n020Lu5cBj0w1ckPdZby+yn6U
	APoZaEW9fR42o8Aq/lqfT6cHVnVoj2wNWi5UFDXCr0r3P8v/ojRPd73ruRPhvc/ts33G30LWufP
	o5VYOTndKSnlda4G8Yvw8z1Y0cTLJuIuGbrs7KxVMdeqlugHfr4aW8PPn1dMN7n4NaEr3Hiz7sM
	in4jFSmJSaZUCa+aBCovx1daOneVQSqtTpU3oX9KnfTthBiHDbHKcNP/ci9GwSkAFhxGzlVdBTi
	iNu4gMwpiZ712XrRioOe2UtHv0Tz4DSBIB/RTh+Uipfkgn4cgVyU34P+MMgcclAo4SjB459Nd7F
	BSe/R+pA=
X-Received: by 2002:a05:622a:5793:b0:54f:863d:92c7 with SMTP id d75a77b69052e-55ac786019emr462181cf.41.1794503702764;
        Thu, 12 Nov 2026 09:15:02 -0800 (PST)
Received: from [192.168.50.231] (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5550af5f339sm78250641cf.9.2026.11.12.09.15.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 09:15:02 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 05/13] mm/migrate_device: don't collect a range twice
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
 Rick Edgecombe <rick.p.edgecombe@intel.com>, 
 Josef Bacik <josef@toxicpanda.com>, stable@vger.kernel.org
In-Reply-To: <20261111-mason-migrate-et-al-fixes-v1-5-3d2454362e8d@kernel.org>
References: <20261111-mason-migrate-et-al-fixes-v1-0-3d2454362e8d@kernel.org>
 <20261111-mason-migrate-et-al-fixes-v1-5-3d2454362e8d@kernel.org>
Date: Thu, 12 Nov 2026 12:15:01 -0500
Message-Id: <179450370120.482102.8019443935242743968.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Stat-Signature: 3diu63k4dttpe46s91y6qmtdxxcp7a3b
X-Rspamd-Queue-Id: A02E4180007
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794503703-30519
X-HE-Meta: U2FsdGVkX1/kosl+IaobE2VcuuoAcwI8gGHYsZM6zb3AOmdfylP//HbJkvCKys9mpge+E02elbKH7zZS5gTR/ZlN6qSotjN99USR90PydrGqsYL4RZEEYIN6Nn86dwYcduhWqwrdSYes+GVPYh9Jk+61cUtqgHYVd4h/3aBRlxmXAebQy/6Ape4hMEdXmo9p7RwSDxBVZR2LEXEnqML0rvtPYLJBmlRZfJNfZilzYYQd9rwyovHdo0/nXuItAAvC7Gv8FxjfhDFxpLI1rZKTEIo4Mc9LwLCzwxcd+jeuESwyNxmCF85lyfp+vLL6rGaeX1nHk3fa9dIh+ResdvtraW5+G1M2gO4aRKDgKSrC/3p6K8hOra9nFLFuagXpIAoFAAX8qxgWEWclJa0WRcpRqgkw/HpTDU2GYJFbeS1jL8G46lV0MQnSbfwmT5KXbs5qJv3oey+/aWNwTQDrhaZeLG7f47pBq1dtjS4egmxUiyb+35RY1Ixzm8Mby3t+nugbk8TR+2zZLnWIT3l3MmFtn+je0DW7R+3HVdbz+1bKhnq9ssNIoDCZi/WbiFIIswOBnu6mZ2Z7FOfleM7b7+XVEKkEjkkfR3hA5OyQIrRYcQFUE1eyjx05qAFCm5f/rlCICKkLrj6jfx2WRZ1iCHRaC6F/hv/4tK4/60k8DQSu1ddytgU2jtknyH73kwDb8SZKbTKFmfeKjWZ8p1L5TkL67od7HqzbpX7h6ibxUYO/EYLeeqTptYN+7BhVt/jTIYF78ICdEzX6JjlZx8mYv/SvXbM+NB3H6tCjRKsSYVyoQHaC+fklHCWwRkx8hzJt+6pWFL9h9uaF+tYxaMatc4lZbqQ4yeZJppSiD0ebO5deSSu6+Er/Z7lWv3fd3oKuobAtxef2vgHZvtt597hDieshjvw8Wl9Ee5hwNF/sQ/Y6eaf/nhwVRX6o5+3yA1ZHIPrRKBolAwGMv1EAcDB0th7
 BTu0BV0B
 aFo7yMw8B9pdiWX0IP57HOGHQoOhQ85Cg+U4bjTWPuLaOdyjIYT6iM4wX1kNaRpCptemilz7OdLtpsEpekaDsrvcNcGQs/PBKMoA6E1IAg0OPG+IdAoj0YaLgLSoLeLIBbct6rDBs8KRIIlbwCF413F9l2QiMSrlkgG9lveVlUEhRkTwSlyfuXRfaWUOJyQYeEVw37MYmKfOpWjbnmrh5o1P7WCqH21a8CQRUOfP1ztKN7+BkuRtSHH1mhxl1Cj2dTNHW47fYBd+HiPg8BRkxfEJtk8pxah4/G5jR10m0RUZVoPizXLBr/aTxotCRFSMjF5YQ42E1CsePSS3UKKTPNmvIMuhwqFR4v7KgkUiiNgZXkaM/jUM5ccpuQEuq+YAj7nfpV90rKP8Q0N8QJ20zL5WnWtsTPoqDktOyhORMD4+IqU/FOhWuviqWRgg6IH1HV68zskUS0X3Ege6nW3wUcECzCA9ZzLLH82OCVfLUzMMd1Xx/ZTZDWDUtJSTmFT2P/CvBLNKORtUqpKs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-11 18:13 +0000, Lorenzo Stoakes (ARM) wrote:
> From: Josef Bacik <josef@toxicpanda.com>
> 
> migrate_vma_collect_pmd() drops the page table lock to split a large folio
> which it finds in the middle of a page table, and then starts over at the
> "again" label. The entries for [start, addr) are in migrate->src[] and
> migrate->dst[] by then.
> 
> While the page table lock is dropped the page table can go away, in which
> case the restarted walk invokes migrate_vma_collect_huge_pmd(). However
> this is passed start rather than addr, so [start, addr) is collected a
> second time.
> 
> This can result in migrate->npages exceeding the number of pages the
> caller asked for, and therefore in writes past the end of the
> migrate->src[] and migrate->dst[] arrays.
> 
> Fix this by only handing over what has not yet been collected,
> page-by-page, and flush the TLB for those entries which have been
> previously replaced, similar to the other returns in the function.
> 
> Fixes: 022a12deda53 ("mm/migrate_device: handle partially mapped folios during collection")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> [ ljs: cleanup commit message ]
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reproduced and observed the out of bounds condition with a KASAN kernel.

Fix looks reasonable to me.

Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>

-- 
~Gregory



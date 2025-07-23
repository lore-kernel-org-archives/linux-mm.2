Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D59C9C83F1A
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 14:47:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8EB4A6B00B4; Wed, 23 Jul 2025 10:47:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89B776B00F2; Wed, 23 Jul 2025 10:47:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73C466B00F3; Wed, 23 Jul 2025 10:47:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 637EB6B00B4
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:47:03 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 419131DB6E6
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 14:47:03 +0000 (UTC)
X-FDA: 83695806726.01.64F62DF
Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	by imf26.hostedemail.com (Postfix) with ESMTP id 4EB08140009
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 14:47:01 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=soleen-com.20230601.gappssmtp.com header.s=20230601 header.b=f8182Ce3;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf26.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.177 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753282021;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gy3J9QeC6eXj3cGR0pgjxNs/6APC+1lztNiCJckBgPA=;
	b=X4+wMoh6GjjuExFRJfpAHmVeken2XyTBUb6XenD0LQW3F6Lt17IIOnyXxLyyZ5dJJrvoSx
	Gil58JXX8eS+3Akhm5+Gcdrr7IK0kWNR0NxjoMFihn7ZVgIGv9gPCKB2yuS19iMdUsWS2A
	FpIA2gvPefjb4aaYTSjgHXR6ESuolVY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753282021; a=rsa-sha256;
	cv=none;
	b=XD0Nl1H1C3cOqxnBA/65Ep2tBEGnCN7zVCFl+4jA+VgukDVYyDl91E3m98eMqPpobJzbCv
	2qc0D3SIt4SHZrCabeEHpUBZdwGSo4vV80zz+pQX8kJY86A2kPJsPHy24LnbOz7SA6ZaIu
	soSPAV6vdoygff5zGmDyQQVuf3YjD5o=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=soleen-com.20230601.gappssmtp.com header.s=20230601 header.b=f8182Ce3;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf26.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.177 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-7170344c100so58946457b3.0
        for <linux-mm@kvack.org>; Wed, 23 Jul 2025 07:47:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen-com.20230601.gappssmtp.com; s=20230601; t=1753282020; x=1753886820; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gy3J9QeC6eXj3cGR0pgjxNs/6APC+1lztNiCJckBgPA=;
        b=f8182Ce3u4qnRpx3B8V4jXAH2q5GCwhMSZ1qY2wsmyuEVRGNG++z8AO5lW9jXlayqt
         UGpqY5InD/CaqybMaNWx1T/F+J1ONFod2/2Grhn6ATDLcp5cO8F/73xZflMF2g3PsvQn
         V3dT3ImM1x64ea85h89bt+UDroNxMRGcJD9Gf0ZoM28uBHUCZyA74lL/QUJHWF1sx30N
         AtTUT+di5bxtu0SWloWerYC+dWmsF6lP4wJoJJVjtRX7D25Bznx6O0vpSZI05bornevn
         TBpKHLC+pTEMhswTuFt/W5/Q6BtQP90uGQlt49irQc7V9Mp+y5C9+20IS2ijbDrfmeFD
         z2FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753282020; x=1753886820;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gy3J9QeC6eXj3cGR0pgjxNs/6APC+1lztNiCJckBgPA=;
        b=dU8TS+TlkcdzBQnpmLX0zHiAUm4JTCxvevHpVkHH+YNFwbDL/JV7S759iNcQxNCosM
         WMH1irl0zgYjebZBhJDteNqs3SPBBK5iYa2d9kGvuAQvpBrWy7yLjve4S5IZeMoUiSaW
         uRib9VHLbyyzBs/kQkNTl/C0zUbAwnVUhNGxO/MOIrXnKsPJYjw2rbAIeDbMi95Bbh7w
         vvPJ1/4pqbKqeWskYRepfI13YaTXxHoIDz+6aLbsaPMW0w+JZF3XnWzW04UidPpUvpU1
         tdtNmpjbF2Euhn0VDuA7Anohkp5HoI5VutMV+usK0Mlh+xkgNPVTBOmzLI8ja1EjieEx
         bZqg==
X-Forwarded-Encrypted: i=1; AJvYcCW4Bt2vcFg/iCOiK2Pcy4r6LuJu3a5uRY8DbdhipvAC6iGjvyFii11MzQaFg/s3yrBuslLsGVNs2A==@kvack.org
X-Gm-Message-State: AOJu0Yw6Cqf6Ah5tw2HgTHoE8p61zhf/obV+Q7pB8v1JmrUoTw6o9z7F
	klV894W2WJ77Icp9fcyM584+K42EtTY4Q4wdx8kK7kgs9NqwSqXozlz0jCrNf7yJFgw=
X-Gm-Gg: ASbGncuefh2Ix6ozt/FUOcSwTV/vZCVIN75idvNWzoXh1cjHRETjtVsuOQROkWXqUsk
	C8AopCsz7+uDa997D1tD4LAtzek/0Td3plxbrGvcn+UV6AMc1R5sakA467geD2vwlQa7M7SFVVP
	5Jjf7t6lXLI7YfgE6kOLISKoGMzIGwz4y8R33D29TtkJuFa0RJtZtVPNwQru+yq9Cw8I+3i68+4
	9ie1c9YbDE2cvDn7YsSrJFoqil2PrwUNLWPnlHMsT/GedhyLz+ZLslnB7aRkNK9h8cTWgPedB+W
	7uTdDgLBPKkfMG9WIA42jTrsJ1DHicD+kA8zAniGoxwoVsGwD1g8CVisR6HfoC6aD9RbyzQpJlZ
	Y8DZV7SB/+N+/hsB92liY9EDpfICZcSEZNF1MbBBoW/8gDfRBl9Sd+tDD8xB7W9wSSrjy+3eH9i
	2FbwfJDpEEMwAuIw==
X-Google-Smtp-Source: AGHT+IE8V9tRE54MK48zflOS7PSA4HAhDqRjtC0UhDc7I1+H3UGz76R3OVDEkrrQ9nCRF167WfSdiw==
X-Received: by 2002:a05:690c:74c3:b0:710:f1da:1b5f with SMTP id 00721157ae682-719b424d284mr43181487b3.34.1753282020293;
        Wed, 23 Jul 2025 07:47:00 -0700 (PDT)
Received: from soleen.c.googlers.com.com (235.247.85.34.bc.googleusercontent.com. [34.85.247.235])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-719532c7e4fsm30482117b3.72.2025.07.23.07.46.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jul 2025 07:46:59 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: pratyush@kernel.org,
	jasonmiu@google.com,
	graf@amazon.com,
	changyuanl@google.com,
	pasha.tatashin@soleen.com,
	rppt@kernel.org,
	dmatlack@google.com,
	rientjes@google.com,
	corbet@lwn.net,
	rdunlap@infradead.org,
	ilpo.jarvinen@linux.intel.com,
	kanie@linux.alibaba.com,
	ojeda@kernel.org,
	aliceryhl@google.com,
	masahiroy@kernel.org,
	akpm@linux-foundation.org,
	tj@kernel.org,
	yoann.congal@smile.fr,
	mmaurer@google.com,
	roman.gushchin@linux.dev,
	chenridong@huawei.com,
	axboe@kernel.dk,
	mark.rutland@arm.com,
	jannh@google.com,
	vincent.guittot@linaro.org,
	hannes@cmpxchg.org,
	dan.j.williams@intel.com,
	david@redhat.com,
	joel.granados@kernel.org,
	rostedt@goodmis.org,
	anna.schumaker@oracle.com,
	song@kernel.org,
	zhangguopeng@kylinos.cn,
	linux@weissschuh.net,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org,
	gregkh@linuxfoundation.org,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	rafael@kernel.org,
	dakr@kernel.org,
	bartosz.golaszewski@linaro.org,
	cw00.choi@samsung.com,
	myungjoo.ham@samsung.com,
	yesanishhere@gmail.com,
	Jonathan.Cameron@huawei.com,
	quic_zijuhu@quicinc.com,
	aleksander.lobakin@intel.com,
	ira.weiny@intel.com,
	andriy.shevchenko@linux.intel.com,
	leon@kernel.org,
	lukas@wunner.de,
	bhelgaas@google.com,
	wagi@kernel.org,
	djeffery@redhat.com,
	stuart.w.hayes@gmail.com,
	ptyadav@amazon.de,
	lennart@poettering.net,
	brauner@kernel.org,
	linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	saeedm@nvidia.com,
	ajayachandra@nvidia.com,
	jgg@nvidia.com,
	parav@nvidia.com,
	leonro@nvidia.com,
	witu@nvidia.com
Subject: [PATCH v2 03/32] kho: warn if KHO is disabled due to an error
Date: Wed, 23 Jul 2025 14:46:16 +0000
Message-ID: <20250723144649.1696299-4-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
In-Reply-To: <20250723144649.1696299-1-pasha.tatashin@soleen.com>
References: <20250723144649.1696299-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: zyrddodsd5w6fxdqwz9iboxit436msat
X-Rspamd-Queue-Id: 4EB08140009
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1753282021-790248
X-HE-Meta: U2FsdGVkX18RZQLP94siw1uaEJ8HZT3oszUqovOWObCKc4qdcIu+WqI6H0XJ06/bBXoiZh6pRpIFe+2uw0UT2J1Iw0Iui03ErIC6bNr0huRSI66FoTgj5qDN6Eyklmril+UDjuGRtGHgRdNQ+EA5fQlCpDhaUreeYc/B8E/0cABZ8oRTNngrRrX1HGpG4d/etCk/reKMgM5taex/6FJdRmQvaAsfXgfatAATuXwB8b0qkrRCXl/ujG5ImTC0dGauzsBqLy1CWdSyFF4qttGA3rEicewUCXPLVZnJl3KRRELx9chR07O46gAf49D4jAPFz0Mr0uSZkdItPcBSQBVA73DOlAu9rDcCOH3L1D6YW2ZltOg8qi6VWKElbN5X8If3VpEgMEQcxGyplS668ClRtM4JGRTt+MHqdzsKtdtpyzZ6cyIyVc0sM2S7QxH8W7kaU3gM3CP9JRpKYzZJJ57NxYMNxrZpmszVkvo14jJMVlnNviNr6XJRVg4jiMmaQ8R/e5ompwiMrW8a1hzZnBFqVchHW/p60aA5tzejDrQlo5Vy3ou7OfIVCF6Mm39NagObh0F2reLQNzgv/VO5f6DVfG0TBfA/q7peUiSPpCjFmupWhWMDxJhN1D6kkgS40v6nihlmprZJs7odjKVlL8laeRddHSQ8FJDSbVenwwvObcEew8avUpuxmia6+K+H6RCtI1u/gcYpVtsT6pFQk88Zg6o949RPbeYJwvTI85nFjJehhnpyitXtqf0J4EFnxO7eu9ZgbVNWGEIpGObvEQ4qHBoMAnILNIPzK2SCSQR1YIupIeTl6jAvTVj2p4UcB5aGuTxV6ezNudSxB1coti6CH922xL31ldHXfD6U9quZzcu0kptAWQ+mhF/PqIoDqx2arqOV71V6gFz3hIqVAiAEuYbV7IMQCI7BEBENDbtttDITfjVg2E2JgIrivTEniR8wxr0g8KAcoXFCfUV8qLB
 VfbqZ94H
 J9dnEYryCXrx6pOOB36y5YkCh9CAi+AURkI/Wm+AWriShhh9k6AKm/ANu2rw2qHDKwZUZxAuFBJQ9Raw8qsQkC47OyWvcaNC/6zpGDPUvEg3i7b07gNgIleilCtQ9vFbBDHyUtqlTex0oTzEXGDLH7juBeFGD4cF4qFuUjcz/5H3NgAPrYFSkxHsHxc8V1jDQJh/pqdnktDa6d7FH4Z1AhZ8XEHaCh5rN/MIxmH+U7W2YPCdVNMgssrElgyqhGFcvrAUfMvYTUw7pp9AvJxYUoxYvXam2alASvWEpDkS73eTeUuNohou7vHolanB+WmWaaiUijGea2jzDWBkNYS3x6XjjCFRh2g/0MrsVBBTPzxMgpXKk2rA+N6hEZno1IFZbdG2Y5w9lqK0AC6msu8n4nj6uBDJ6Y46N8q25Br+u97nZUF0NTmiGRBSjgtNEQcoDheSKyEAhZt24uNtNg0g39hYHneWMNWI03oedkmDBxAWakUTYQooDFvaLPPRUr4FMqc7P7sPNvY/RDCe2TGOD22OZcg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

During boot scratch area is allocated based on command line
parameters or auto calculated. However, scratch area may fail
to allocate, and in that case KHO is disabled. Currently,
no warning is printed that KHO is disabled, which makes it
confusing for the end user to figure out why KHO is not
available. Add the missing warning message.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/kexec_handover.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/kexec_handover.c b/kernel/kexec_handover.c
index 1ff6b242f98c..368e23db0a17 100644
--- a/kernel/kexec_handover.c
+++ b/kernel/kexec_handover.c
@@ -565,6 +565,7 @@ static void __init kho_reserve_scratch(void)
 err_free_scratch_desc:
 	memblock_free(kho_scratch, kho_scratch_cnt * sizeof(*kho_scratch));
 err_disable_kho:
+	pr_warn("Failed to reserve scratch area, disabling kexec handover\n");
 	kho_enable = false;
 }
 
-- 
2.50.0.727.gbf7dc18ff4-goog



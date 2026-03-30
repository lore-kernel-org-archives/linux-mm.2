Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7823910D14A3
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 11:41:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CC9C6B0096; Mon, 30 Mar 2026 07:41:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87D656B0098; Mon, 30 Mar 2026 07:41:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76C746B0099; Mon, 30 Mar 2026 07:41:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 617746B0096
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 07:41:56 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0AA6316075C
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 11:41:56 +0000 (UTC)
X-FDA: 84602540232.14.0277F2A
Received: from mail-dl1-f51.google.com (mail-dl1-f51.google.com [74.125.82.51])
	by imf21.hostedemail.com (Postfix) with ESMTP id 319C41C0003
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 11:41:54 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bDBZreqg;
	spf=pass (imf21.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.51 as permitted sender) smtp.mailfrom=realwujing@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774870914;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O8qbAM+0abt2Xsw25EiZl6rgD9G86cRKj274QNi4sMI=;
	b=2/kUwwysHihAntymUvjaF1mC3XrGkdaT/s9T4A8Deijj2eIB4yjsRN4VOZ8VQaREQ9lvAP
	yzF9WAFl1bZEU09sw9xkB1gjxi137MUbtYPX5CC5qEjwp6L98xJgmoVBR8PGh36OBkUaZS
	FkMqNvQO+kDcsXBTKa/34gk70FxVOp4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774870914; a=rsa-sha256;
	cv=none;
	b=h50yTJkDnLz9J5kUAHxeZ9FO5nSNpxCu+CsDVU5GNJbnrcofmtox4Zu2MO7CP+Co3ZO6Zw
	AvIPMSo7/mZjAqmkvYffV2uHZo2CuMfSKWCTWk9f3XsK5epCUnyFJhyhx1G0l1qo9TGlFc
	YeZFPPnyMrwmHyhodlC+DmDANjydlJE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bDBZreqg;
	spf=pass (imf21.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.51 as permitted sender) smtp.mailfrom=realwujing@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dl1-f51.google.com with SMTP id a92af1059eb24-126ea4b77adso5956540c88.1
        for <linux-mm@kvack.org>; Mon, 30 Mar 2026 04:41:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774870913; x=1775475713; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O8qbAM+0abt2Xsw25EiZl6rgD9G86cRKj274QNi4sMI=;
        b=bDBZreqgdMt49hC2o6hwvKYSR9Bx1uZY5Rh567fQhLx+aVXNF+Pgz6KaA56ZVl0z0/
         vRF7wI9BcadOG9yusGg8zNPYaOMTL3t3omVOBrPEIzJQATVL1g2lptamW9RN8BYYuDZ7
         tp3TrC0DQQdDt6NeFImX4D++Fr+7Wg+f46wZnvsvVfq9punpwWOpXYlaf2r2miF7b4c2
         IMd7LKmuQgjjr68s3INAtlBC5RToOz6MPglBVsENEMGBkFakJKZCtiyqYM3wKGyyH3WT
         khYPxbPTQmEM/jPTMf1foXgxrH+SSgWxi/989HJ9iDx6ZF941/eRrIgWOz4YURYoGSyK
         grig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774870913; x=1775475713;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=O8qbAM+0abt2Xsw25EiZl6rgD9G86cRKj274QNi4sMI=;
        b=n2MtWO+1C+TDAY3ytLKNySohbHBDMN4ad4QFBMXGMeoMuVCqQCDOZpKFw8FUowW6Tf
         dITEIb+hhe7612ZELrCWYj9eGbMPerroGNL+L2AGa2U4UCEVVGg+yGv2E4lCN1NNDkPc
         HAu5yRM1MqUSWS5ocQP81C2N4QM+N368qu2NOH9XTSbD1EFFs6UYzIRanboC2lPSiKdQ
         d7vVBXvTxetyodS8MwigIQToS1H7FJKunlGgNNov2rIwwHI2Kc6034gdfjEpIKukzg2P
         Ju281SiOIeLhcgpUGsSIMvQ7VGpShkT6h+N5o5nBYg0zL9qMv9ctesuliEx55aiMOu7c
         Nx3A==
X-Forwarded-Encrypted: i=1; AJvYcCVCe0szheB1LPDQtleQooAac2tmBsIHrIstBJXxB7Y9pNV3ClZF6CXcO9gpaVI/lTNaNXsc9IiqrA==@kvack.org
X-Gm-Message-State: AOJu0YyEEIeLEwGwHtOeBZUugyny6tesTMKIiDi/4Yo6CKWd2npIYGyh
	eAMB0gr+EGF9fRUqT8G639r6/JfPg7iFhp9jmmpMOtERXf0jWZC255L7
X-Gm-Gg: ATEYQzzVjrI7JmXZ9lPnjfGkFj0Eew+fMqcKm+xqiXN6kYRl8X1ObKrnHK5JxoVOM0G
	dD7NjZ9sRUI7+yGJC3pN6wsf/6Vp257bGZX2c6G8iOc7hI5/rHHAtPKbjA1uogNbsOOxd+I3OdC
	c0iuYMBEAuZyMVfp/Gj1ZcZ9X//4aaSz+K+myK6FtYvmGJE06OrlbIvbb+PEmIzUZX9YVbs5k9n
	A8EzeNVB5aGrgQ70JetBRydfn/2btYsx+cDAzkF0x2PKmCUsRJm22dkIEp019dQ8OZoT9U8r6yh
	JCWaZUxNonxgV/4Rf9bfdmBlGb2zb/mnhMzeuGboA4ZmGRUSPU6/nbW37aF314SKlt7T1fcmyD1
	TQ7WjKQF/IUXWuGsugBcrAV/RvUJzyqQwtzGjzL61N/gCUoU8WXN5ugX1DhazP0wMJbDmoI5JFh
	8w5R2X5Y6R4fKlPjp0aKEzUFI+rfcl6P2z+4o=
X-Received: by 2002:a05:7022:4393:b0:128:d396:f2e2 with SMTP id a92af1059eb24-12ab2857b2emr5938952c88.8.1774870912754;
        Mon, 30 Mar 2026 04:41:52 -0700 (PDT)
Received: from localhost.localdomain ([74.48.213.230])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-12ab97cad88sm7602987c88.1.2026.03.30.04.41.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2026 04:41:51 -0700 (PDT)
From: Qiliang Yuan <realwujing@gmail.com>
To: tj@kernel.org
Cc: longman@redhat.com,
	cgroups@vger.kernel.org,
	akpm@linux-foundation.org,
	anna-maria@linutronix.de,
	boqun.feng@gmail.com,
	bsegall@google.com,
	dietmar.eggemann@arm.com,
	frederic@kernel.org,
	hannes@cmpxchg.org,
	jackmanb@google.com,
	jiangshanlai@gmail.com,
	joelagnelf@nvidia.com,
	josh@joshtriplett.org,
	juri.lelli@redhat.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	mathieu.desnoyers@efficios.com,
	mgorman@suse.de,
	mhocko@suse.com,
	mingo@kernel.org,
	mingo@redhat.com,
	neeraj.upadhyay@kernel.org,
	paulmck@kernel.org,
	peterz@infradead.org,
	qiang.zhang@linux.dev,
	rcu@vger.kernel.org,
	realwujing@gmail.com,
	rostedt@goodmis.org,
	shuah@kernel.org,
	surenb@google.com,
	tglx@kernel.org,
	urezki@gmail.com,
	vbabka@suse.cz,
	vincent.guittot@linaro.org,
	vschneid@redhat.com,
	ziy@nvidia.com
Subject: Re: [PATCH 00/15] Implementation of Dynamic Housekeeping & Enhanced Isolation (DHEI)
Date: Mon, 30 Mar 2026 19:41:21 +0800
Message-ID: <20260330114121.101232-1-realwujing@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <acQHKwGhYrpoOH1P@slm.duckdns.org>
References: <acQHKwGhYrpoOH1P@slm.duckdns.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 319C41C0003
X-Stat-Signature: 5mz8qyiaf4583k1mrbbgf5haxn7hgnhe
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774870914-876176
X-HE-Meta: U2FsdGVkX180G2/RfnF5g0HA6JjrrHXnovnNqgLDFpiKWySUQmv/nbnjFTfN6agFrzxmUOX2QQQmmXhBg1CihCA7Egb87u7Iwdf0Rh8IKkSaNvVES8sl/z7yIoR9tDMUQGxMXY+cQkCQVLQPeUN7KIr2WZIxYIggEWuggAYreDDpzevKAOle90bDJjn2ls3cPkiYwPNkyGvdzFfQRKvmrXIcuOShd3cF+dY1gFlL2r9JMiwXckCf91X9Hm8VHWYfmtMcTsrRsmUHEuh/QYLdU2xi/8cECArmtDVpd23E5+zU0ZKvIJynXFM30K4lVHtFN7ShuNEQtbt1cGMlQiw6O8O2Ik7DQffksevdpBXhIS3yz3EjM6xwSapvgWGarGPTLqzzJKu/VoYepeaWn2DcW//F13tgwLGIJWHHdTV++yMS/ZMDJq0FDiQ+90hKkK+sP6FShqcq99XY1QLa0q9KEnPdRPixBYydcJQJnxw2Hi8MxZw7CvzWD1qYPC9htoER9vPV8s/Nedj2PusW9fjoTmL/NdMTAzW+aYDWxGV+oi1XbNfhSKN7LK28GaiaZCJqxKqg6WF3iUOakGLbmWP6XsucirulpuP9LF7YRS276ewjN/e1PNgmr0YtIJBjUhkvVbwc3bMBVzck32JZLHQxaUoLFUhILDR56FvVuRlfdwf+ZIsFK/8cZpV1+XZ6mkn13k3wZs933qhKv9zbxyF9RofiQoikhQmK/yZr1JC4XMdOz8IB/Xj7F0xKBqgSnHjd6Ol+Mh5eEtDEgOMZdAX5LqULUAPBFB4PEqnEQqPDknBrKy3nwr3RiiMb/t7nI9cHbnsdsy5b0SDLbxZI2OkrwHguSPBdQRPQIQvzPnfOKwKgYlIbZVxkPzxrZocngEx3X64w063NzzikGr/OMpKjiJ3Edc9GYnRRPi5vYTQA+RLPHkQSxFyaKKKsJ/ig0/Mb0iyMotFwosLV7mbKqz/
 j/0xvkvC
 DVPWtIkTCKJKtBla3Nfl5ghiaZcN10xIN+PzEfKijpB6CNGUyrsHEQmsub2Wg/rwk2sWduaw20apm29x7MBv9r432jUR4OR5Ic8PaBBbTjMek7QFIEtipYDw2M88IameSWXBKSlh/L9s+aveNiiECGXXzI8+N54RCm9T+6IA/gBxWmCDibKr/R1WWz7GqrE8jNshTyqv3Dtr95T7+l7ABo4WbUMExdUigpiSYvJ5hHUzK+IWGcBvsvwY0FsteLoeAjGGNKLb1mtv8BwcBwbdvDcfL07Agu0MmR/xGL0YSgVlp+SnqQ6rzY5UT2UcKdKYD3PpPMkX4OmxlNeOvaTWm3hqqjlsZO0vldvi/ZrCYLHZ4siSl7N88NLnT89jpjDtruGY+nPMhhLORIsqDdH3IavmX0Yk4YB1mSTLgg17YIuOEv0JS6/NBKv23B/dVMpW58fO182ZQHGrdCI3YgBK1KHjXr6zj7D244sKdhz3x9p2IkFnq9CIfvAVvtIqz2jyb7dIReBcnUw/nXWFU7WAVqIKEvDkGa7w8Sm+z000zfcPSwTdkXc1NOE7QYzSSqGiwHFWM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Tejun,

On Wed, Mar 25, 2026 at 04:02:44PM +0100, Tejun Heo wrote:
> This needs to be coordinated with the existing cpuset and isolation
> infrastructures.

Thank you for pointing this out. I agree that coordination is key to avoid 
fragmentation of the isolation logic in the kernel.

In V13, I will focus on integrating this "Dynamic Housekeeping" logic 
directly with the cpuset subsystem. The idea is to allow the root cpuset 
to act as the orchestrator for both task isolation (which it already handles) 
and kernel overhead isolation (which DHEI enables).

> Also, Waiman Long should definitely be in the CC list for this.

Acknowledge. I will make sure to CC Waiman and the cgroups mailing list 
in the next iteration.


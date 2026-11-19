Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73B43606A336
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 12:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=GONRuns4
Received: by kanga.kvack.org (Postfix)
	id 8C77A6B0631; Thu, 19 Nov 2026 07:03:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 851A56B0632; Thu, 19 Nov 2026 07:03:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 657426B0633; Thu, 19 Nov 2026 07:03:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 38BF46B0631
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 07:03:14 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B1A2080AA0
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 12:03:13 +0000 (UTC)
X-FDA: 85451733066.04.6902480
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id 3A33818000C
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 12:03:11 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GONRuns4;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf24.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795089791;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zApCp1xwVg9dKanzxdxazWSeTQXz+Vf+a7PGogJltFw=;
	b=rdqA9c/c03VGRyd7JtbqOcCklU4ZvE76LauwxpFGTp1zgiqYuOkDR/Y+jGh4xFa2adWREG
	LY01FkZMy+Vx1wMYvHHl4ASxgKpqvckTYFQr3Le87sco8iqyMfoiuK9s+p/mTBhnZQvOfy
	H7SHb+MdEBSVXFoxQJw4gK9ljAM8xrw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GONRuns4;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf24.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795089791;
	b=Ph1MTfwyedBMMzdc5U3cFdcXWlP1Do5bWg3b94spZIQZFCPvpoWoxFKHWOa4XiN0UFNSIS
	gpw0jWQyQKgL8fD3zdlGG2qPC43yxehHD2gtiyFPYGewUiiU8MJn/Qm6p84Mr1cPmLtkTx
	MVt5dvATkP4Dnsx/3t9FHLYJr6er1v0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795089790;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zApCp1xwVg9dKanzxdxazWSeTQXz+Vf+a7PGogJltFw=;
	b=GONRuns4tcJQPVGpoDG2p2zXYyihcoVRpfizk0Gq4iqlG4T8XUoYmf+//JZ2ZWYEbd9Zb/
	Oyf0d/HfMs5k+/uxpPkdQQeJUMJGbaqljBcwRAzr6BTbpBNIz5tCodBRTFX8qnQq1knfRV
	DnHjm/Ts/IVRxjOE6JUp56K2Ap2XERI=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-94-YUSJNFnGPkSSswpTC3dwJA-1; Thu, 19 Nov 2026 07:03:09 -0500
X-MC-Unique: YUSJNFnGPkSSswpTC3dwJA-1
X-Mimecast-MFC-AGG-ID: YUSJNFnGPkSSswpTC3dwJA_1795089788
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4a359b714f8so13039155e9.2
        for <linux-mm@kvack.org>; Thu, 19 Nov 2026 04:03:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795089788; x=1795694588;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zApCp1xwVg9dKanzxdxazWSeTQXz+Vf+a7PGogJltFw=;
        b=KK7zYMH7570k/N5ExIO61HvyBlkogXA6zXfPAkOHGs9Pdkc3hVBjq7ZJwVKy7xeRgt
         82DuQqOAxx2kk3lt2Xp4JxVfDnOIGIAkZdHd1TrWF7BLJkVEBIl5m9Zi9u2KZtzR2Vor
         6uOt3hM6tqnqCuZvww/SbnmKPvhHTouLGo6J0d0mLCHzhuVVodD0LskO+0S0szybWP8s
         tUCKx/kG341/hFcDTxCx6yQtDy84NyQ6/XwmYSGME36QNaK6ER0A7jPLC9apF50e1GHA
         wzm43JwRDrZyPpy9qoTbTiaQ06DwtaGRjStPcyqyutu209frJHJRMV3dqP+YG3dzbgkG
         a6Cw==
X-Forwarded-Encrypted: i=1; AL+hErF+nOTIDWvzXi35+iIMsDSOvbHE24Sjnmm46056Tn32z31ds0Uw6M2fJPysIo+dRrVdg+Bt3fphrw==@kvack.org
X-Gm-Message-State: APuU4Z/ubvokef+hUPePFjryYaZbsxhfjr9j98utDmO+/oFmuyaVlqi+
	CN0wVsRi41NV4m4az/KOoIXqA9DXQCeXCUvAo4u/4JxP2EONGHAFdb5EGlef3prpLhJkjq/pecA
	qJY613vxOIar+b6bAv6ITTmjcZObhxHyGLsRuiw2q9FOROtx3e0Nc
X-Gm-Gg: AYBFou3CptaYbp0nqCyxNyS/t95Nh6XODkTh3P9eRtK2bUb661QemUJyFwI0Gn7pURm
	HEBAxDVT59VNv+RB4FPr5pIuwQQgw7eqh9zlf1jXr1aZtyK+app8oIfNudR4L9nEzz5tDjPjm2c
	L8+LCeghgGOskLQ131BsFAtAi4tQDhJWWwli0ylXsI0wa92P+GXuFI+cPfANK4S/C0cnyDVRZCK
	LPLxDr+4ai+4duREuLT9Af+2Ze2Y7D1AHfp3mvwfT0RovEY45/6d/gSm6wRmQrV36C8znbQvwuy
	da9zGlL5Cf9ePydtx4eh/aa/18VnqH4tGDPtLWvz7JXoz6bsmt6FH0frvx+SU0/+8p4fcmYolZh
	7dfMwHac5ZDJY0SUbqubPyp9Lppjqp1b/dI5LioHxvh0=
X-Received: by 2002:a05:600c:a303:b0:4a2:84c:52f3 with SMTP id 5b1f17b1804b1-4bb7da13acdmr100153235e9.6.1795089788078;
        Thu, 19 Nov 2026 04:03:08 -0800 (PST)
X-Received: by 2002:a05:600c:a303:b0:4a2:84c:52f3 with SMTP id 5b1f17b1804b1-4bb7da13acdmr100152535e9.6.1795089787463;
        Thu, 19 Nov 2026 04:03:07 -0800 (PST)
Received: from redhat.com ([2a0d:6fc0:1520:4400:d78d:7b2d:2f5d:e08f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb853b216esm32981455e9.12.2026.11.19.04.03.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2026 04:03:03 -0800 (PST)
Date: Thu, 19 Nov 2026 07:03:00 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Jason Wang <jasowang@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>, Dev Jain <dev.jain@arm.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Greg Ungerer <gerg@linux-m68k.org>,
	Gregory Price <gourry@gourry.net>,
	"Huang, Ying" <ying.huang@linux.alibaba.com>,
	Lance Yang <lance.yang@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
	Magnus Lindholm <linmag7@gmail.com>,
	Matthew Wilcox <willy@infradead.org>,
	Miaohe Lin <linmiaohe@huawei.com>, Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org, virtualization@lists.linux.dev,
	Johannes Weiner <hannes@cmpxchg.org>,
	Brendan Jackman <brendan.jackman@linux.dev>
Subject: [PATCH v11 7/7] mm: page_reporting: add flush parameter with page
 budget
Message-ID: <2d518dd7b8f7be147b9a957ad94f6c6641e4b5ef.1795089715.git.mst@redhat.com>
References: <cover.1795089715.git.mst@redhat.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
In-Reply-To: <cover.1795089715.git.mst@redhat.com>
X-Mailer: git-send-email 2.51.2.2891.g4157995a80.dirty
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: gKBNsRDph8_Jfw4398byBXLLjJJD38tq06XUCyefBAA_1795089788
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: 3A33818000C
X-Stat-Signature: xf4xrsp5uar36cwpdey5sgnj4ygiamwn
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1795089791-279238
X-HE-Meta: U2FsdGVkX19C34RIdvIPa8eVKulV+a+VkdODK25dUoV/X9TH0AjDBGPAQFvmSCpH4dHK6FCGLHgQ39uOMacEcZJduRqD8CXTXWMLdHwuURmYvWkOdGqhZtDZ7K98m+HTe3QnJlOMo9FspznqzLaVJBFxAxRc5I+X692TPEfK7wf3riU4z4hjX6eKZumIyslHEurKwxTTV8r5r4D2w20w+sw/lDmKrB7rve8pOQPaeVz2c8VxsW7LqKCCe1zhPriiHm7A35iNaNiV5U2sEbhcxH7hWQmkbIwvQAD83rGuKKeY3pOZdRIqbv7dYP1F9ql83kUtMz8+F/Csm5kGDs+E44PSLl4Ddmp/K85lE5lJt+h2WTn6Q2OOrL1DgYbUUJRwI6DOUWfES8L04gYossddqrSDn0QhG4oBA2/Hvd1zNKqGkcL5WQPmeEyprkXXNGGYhyx1KANEI89TTBo1Opcy6W/C5EiBDJaAurFOiCjurDWtU9y7PDAUFguf1b5OdzYHQrNE8Rd+f98ydBb/wAsJpanWvPiDkQo4TSmRBnYv6eMfhgxMvPWwJAfoji07p2ZAkF91YPGXS3Q5xV+/GUYPAfWp85X58k1herBmYrmvIqA3bACxgQjlTC+1YtOagtSo1GiMblu0/yS32ZBfFgXYGIkPYFocSvEoVLbEZw3KDgCg22gVjtTMTFyWDD4CXmkfofkVjB9brKmVwtEsW0+UOXc4bDndHzrlx3Rf0K3En+U5nJIRTFkpHB4TrmkYzqJqx3dXy/Jh9SWmHb11JfbStuTSDkrqSDDFdFGTgic5XaAByyQBElCMoeYbK8j/H8/0A0Jj23phJ1qbJZ806PUwd/STBqS+vhvO1+nnm9HL6q8R3OTCERQUNeLO1Hc80FL8IW7oTTfTOsDhZ5WHCGvlhrpsh1l6U+AcRruYaohpwHpAzHc1yv6fve6Mp52G2lM5UYxnXmz6qZu4mC88TOV
 J3QgnZti
 79hWb/CVWW38pql9362R/i3bOmCUugVgCtVbxfuDEASxWbBlXVV+Pf6knQqgcL4M/R4Y7qnBDYoB/WxcMGTSKGdQQp1X08tfJtjGYIyCojU38y9qYtwPgc34rPTl8zNitsdH7nlHcUI1+4LppUpQwsc/hNkdZ3o+tECGP5DPu9MOcpg6XWXVBVHdDI3jnRZrzoE213g30BzrapPMfCUPBlKapyaCxzYImxkG/hzx81q8HF3VhHpYSUp5DJ0kdAHNoy9aPgmcTKi0lClME9yBgrToflX8sGTtv/tn+/V2mmq2LeOzMwL7xpdBH3fLDZMGl0eYxX3/JbFYyFKxeaxXihaaUBGESe4f1GSoRoT7m7QKToCT31H0AayDer18tShCM8li3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add a write-only module parameter "flush" that triggers immediate
page reporting.  The value specifies approximately how many pages
(at page_reporting_order) to report.  And I mean, very approximately.
The flush loops through reporting cycles until the budget is exhausted,
all pages are reported, or a signal is pending.

  echo 512 > /sys/module/page_reporting/parameters/flush

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: LLM
---
 mm/page_reporting.c | 40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/mm/page_reporting.c b/mm/page_reporting.c
index 841dcd64777d1..74c03844fc3e9 100644
--- a/mm/page_reporting.c
+++ b/mm/page_reporting.c
@@ -360,6 +360,46 @@ static void page_reporting_process(struct work_struct *work)
 static DEFINE_MUTEX(page_reporting_mutex);
 DEFINE_STATIC_KEY_FALSE(page_reporting_enabled);
 
+static int page_reporting_flush_set(const char *val,
+				    const struct kernel_param *kp)
+{
+	struct page_reporting_dev_info *prdev;
+	unsigned int budget;
+	int err;
+
+	err = kstrtouint(val, 0, &budget);
+	if (err)
+		return err;
+	if (!budget)
+		return 0;
+
+	mutex_lock(&page_reporting_mutex);
+	prdev = rcu_dereference_protected(pr_dev_info,
+				lockdep_is_held(&page_reporting_mutex));
+	if (prdev) {
+		while (budget) {
+			budget -= min(budget, PAGE_REPORTING_CAPACITY);
+			flush_delayed_work(&prdev->work);
+			__page_reporting_request(prdev);
+			flush_delayed_work(&prdev->work);
+			if (atomic_read(&prdev->state) == PAGE_REPORTING_IDLE)
+				break;
+			if (signal_pending(current))
+				break;
+		}
+	}
+	mutex_unlock(&page_reporting_mutex);
+	return 0;
+}
+
+static const struct kernel_param_ops flush_ops = {
+	.set = page_reporting_flush_set,
+	.get = param_get_uint,
+};
+static unsigned int page_reporting_flush;
+module_param_cb(flush, &flush_ops, &page_reporting_flush, 0200);
+MODULE_PARM_DESC(flush, "Report up to N pages at page_reporting_order");
+
 int page_reporting_register(struct page_reporting_dev_info *prdev)
 {
 	int err = 0;
-- 
MST



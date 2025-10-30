Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4D6CCCF9E3
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 16:43:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1755728001C; Thu, 30 Oct 2025 12:43:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01700280003; Thu, 30 Oct 2025 12:43:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E47A128001C; Thu, 30 Oct 2025 12:43:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D0F10280003
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 12:43:49 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8266E1401D8
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 16:43:49 +0000 (UTC)
X-FDA: 84055352178.12.F5C31C1
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf15.hostedemail.com (Postfix) with ESMTP id 91FDBA0003
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 16:43:47 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Pvo7S2Fe;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761842627;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=103xEl/pexX8xypusx6RhvZj5X/kVNtPLhx7E2RNbUU=;
	b=kvnQSLZOE4c4bBxycJolBgnFc1ydxHhH6WICm5/GcBGg4su9wD+5kO4L5UyWpoFmYzznY4
	vuO11dSXkJrvE6Of9qxwsj3rh0MkFoRIt5WaDDw6Cd6PxZfOPnxHdl+tWenRQmj0/DQpeJ
	E5WQf0VjiIjPvENnulNOnCOfsXP43GE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761842627; a=rsa-sha256;
	cv=none;
	b=LVrYH2JVI2Uh/ilnlKaK++E7VRJ1Z6GeV6jo504RSpIVbL88LsQIUEuSWH5kLeij2ECvK7
	wYhzqMvVH/98ijnjpYJBvz7FwQhUK4Lon76/Gl8hvB8VlKQXI8b/37oY7z1TrL/zzahxSM
	5cQ2OEMNfR8yLBclaaKOLfnsHFtDeik=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Pvo7S2Fe;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-47112edf9f7so10857195e9.0
        for <linux-mm@kvack.org>; Thu, 30 Oct 2025 09:43:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761842626; x=1762447426; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=103xEl/pexX8xypusx6RhvZj5X/kVNtPLhx7E2RNbUU=;
        b=Pvo7S2Fee9DJd4GHeGyCxmGB/orrJh4HdHKlTQNHm/SpXsu83DPJ/w7y7t31X/I+gM
         VXiOPnz8zGadBvD7yzp9mVWCh4yYe9hRvh+EVEA7kXFErcVhMTDP3W5mMQosXAqOTuGm
         d2J7eQy7xTIR0a/0TwsA4FSqXubElg36U2AO1XKauaFHTbJwmfXLBHCDEDzpiOMtVfzE
         9nnzLIUhc1ZZQpbdKj+nPEzabG7MG0GQr/X0ydK9SftRoK3wrNdtFL9PsNu+5XMsS8ZN
         JXERs7XHaU3YwitmXxgjn6ojUt6oQ/iIS8kHRMDnDdL5Zjyo25ktBAeP4x+2bJZxVRI8
         FC5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761842626; x=1762447426;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=103xEl/pexX8xypusx6RhvZj5X/kVNtPLhx7E2RNbUU=;
        b=fDmBIYPWFe8o/S7GbvWqdq4TApxeSGJKd2DF5LmZ/Kj921p7hH83gRFLQVv68u8dOr
         wPvQFh99mcxKng1dA+oZ+QrOnZ3EARqLJQnn5zXX3UQya7vKX1EckV34m2/O8ukLaUtT
         e90wooj222Mk/gD0r4sYMYlWIkz7+JmrCM5B9gOkT6MwijP7UY2mnqjr3GKIbooOu+zN
         JXCD7rodvfiZO62MPaO/qZb7VrIt5ikXGvuj83yUlaEsYDgWTPx8ZRMmmm0/B/VFmAk2
         1G43Ou4OuadN5NL13HBXRb9xCKxdVGnrBaAWDpI2jTCyOzzD78BLCgeNKcNfpye9TSgA
         Wr3Q==
X-Forwarded-Encrypted: i=1; AJvYcCUMbnUWWeVKjI6CkT26Eiij+0c5NN1sT5H2TWrqlVXYPxwfn/YR59hweUgotVK/CKjhxBjVRMqFjQ==@kvack.org
X-Gm-Message-State: AOJu0Yy09XtNgn3K3ebo1Qp8WzMgTg7FASPneexuT/rrTs3m6tuOaFe3
	s081eiDSDGruPRUcNrc2xcMNYCMx79y0KXhET5oG5XT3eMIODcst0zr3
X-Gm-Gg: ASbGncvJSH1Ic8yER72ZJBl4U9hjUhtMVmtQ5vUBg+H0DCSC7vkH6Qmemb/eft0HzuU
	l2XV6TG1aYHwhI7OWwNNlxc7Wqk630Ton9LCuSsnQ9xrcSu1IUtIyWw/PZpbwecnBGGnTQ2Z+eI
	NxejCdfuW6QaGkyz8mr7esLxv/AMnF8fY3XsV4kngdi64/bAXo6cFU4B2Lp9foZexJ0A20Zr/8N
	qf5opyY38BMhdkvsB5qnJ3K4HAow92sHk7i7pqR+nMNppDpliQlhjIPCtLzByC0wQP/3znnZxb9
	w1lR+vSliPgetra8fTrajkitfc5Ocheeh6IUxX3GUBX46oYVpSJtoSLjkO6G0uj4r499wPh1caw
	BNn6Vz/BO8swc8WL+wwFk+acIfWjrbALq1dts7xN++NQgEicKxkg3clwayvWfAHZ5K1f39eyBJm
	wd8L921AUOY+Ew6Cog6TNl1QsjpxULhTZo3nnej3rpYxs2Y627rJ8=
X-Google-Smtp-Source: AGHT+IGv9V6jKOeGhub1sfwVcOG64zM8D6Y6u1YJdObQiDL7PyVDiQwFi7I9EwmD+aig4nvikK+6Yw==
X-Received: by 2002:a05:600c:4695:b0:471:1774:3003 with SMTP id 5b1f17b1804b1-477308be7b3mr4313525e9.29.1761842625899;
        Thu, 30 Oct 2025 09:43:45 -0700 (PDT)
Received: from fedora (cpc92878-cmbg18-2-0-cust539.5-4.cable.virginm.net. [86.16.54.28])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-429952df62dsm36796839f8f.45.2025.10.30.09.43.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Oct 2025 09:43:45 -0700 (PDT)
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: Uladzislau Rezki <urezki@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@infradead.org>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: [RFC PATCH 4/4] mm/vmalloc: cleanup gfp flag use in new_vmap_block()
Date: Thu, 30 Oct 2025 09:43:30 -0700
Message-ID: <20251030164330.44995-5-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251030164330.44995-1-vishal.moola@gmail.com>
References: <20251030164330.44995-1-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 91FDBA0003
X-Rspamd-Server: rspam02
X-Stat-Signature: xg516c1bfuouca47x6xdu6fzgj1g5rq3
X-HE-Tag: 1761842627-494705
X-HE-Meta: U2FsdGVkX1/ScXEVvAca5wLpL2ZF0g92JoBXoz9ug8KVYd/gPuUARzATMJojU8yBHkW4biKL1xm7LoL+pI9n+Etp4gZNvF6vc0RIVEj0StwjqmVZApk18SRtJealZhS5tgvjN0VcekedXrtzPI2tYgOowWuYpx4QixIDAiAWWJYzFahVsGRFrbRHydaSvcERLdl+F/wtWAokMEwJ6zCei4Lw6YmpJ6SP1MvDPqbkQ9t+RVJ1TTGjTx1tBW1solZMSzptS9BN96d1Xb/bmoHEoyXfvhAnMwfU4ThzXwSHlR2mqUZZSRJnmSW1RCiq3vl1UZYJggoeMmvNMSS5w1SW1rh9h5QUDZLaM/xEWGAw/c+RjyRFYsnRVUAfgXdb5OVbp4aMssYIJi2aa/9NfUuxUIV0eQNUb8tY0J0E9oqgFRa/++lDhQN/2h1hw/1siI8o2UzcRJHhE+uQpbLINYnlIQgG1PpGISxf40miRPZoU+9nK5QI0+lki4H36ZkXy1kIzVmVWMo+/fKwCAsXXYCiX1nbOiWDn3UNAW71oNB5h5VBK4CvJ2YiFU4JjOsEeyLmCXSbbgpE4ORszcsFCInpzs9a/6wDOV42+SqBSUN2vVSfd0gRYXXP/S7AtXZgKjOJUi9DnUOfFgXqJLtbuAKw9E5z542eL8980ML0z/01dHmEfJVfCaawbGQL2arHSUYOPQdvg6DC/h9jC+Pfubb8rP49KaVtp0bIqxC1WMovqm6Nk3O91yvg8lB1YkGvHEO2N46GhNM9em9MtMI8/XIMYJY5QipdWfeliePc3n7D2f1unzMwG2WKLWnvDBxk69g99KvSBDG3WmrODFpV6ZaCX2tbz7HwbwAzJwbuzvrgraDPtZgYIznz5PkzM/wJKiyV46jBQ8h2LFNZ3qKOfudSTDAXzREfELfzgYyNj7A5WOMu+rkGdTEHPU+n51dIflvI317rAIykepsFulxzmAe
 Ds6SFdO1
 FjxE85OEjEYy5whH8HlTQ9QCIZDknIf/g+oqtk3L6M+bR6a63fGY96ORJT38azY2RHj1FFQTBpkMYNKiRCcXrfeJzyPPtSah7FlngULNqn2u31n1B8hUFrlkzTzOY8Lk0eV3/EEhUdPWBDDi46IhMjQ2nyxXJO4nT28S8xe4zSJl03Nh4vUWdTRVUlzH24FrqIaa7dLQ3iylcWbCpgiBW++fBmqWkO1sTeI9YjX647QgeGDWFj7qGmTidTcXV+3EUFCPRoM+OaeZDI25SoOKqp1hbOoVA7hlfX8TFSgI5e8f7Dm43mtJuSMpEd/1N81+yLHy+1yb2GpBt0Ay/Ve8OcYKy4tlNnyaXdzhduyDsl/RudzlzUJJTNguwinRbgzzjAE53Za5oDP4IWS43aXEBxmMlcwRJst8LdGoN0Z4cEj/4Y+fYRa9qIMwFZgP0cTb+lPYczxgPrknzdGpLkrN+CIfd1WL8PHudoWMaDFc22jGnBeJJl748ItygAu/g0xLAbW+vEdOIYFax2nD6AutZASLWnP3bKsKuwpaAiz3mZFJLXp0xFfnIkMGL+nS1o90FjjWlPTdWi0PwiQ+0K/iKhGWvUQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The only caller, vb_alloc(), passes GFP_KERNEL into new_vmap_block()
which is a subset of GFP_RECLAIM_MASK. Since there's no reason to use
this mask here, remove it.

Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
---
 mm/vmalloc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 8ad0451a7bd7..0259cf59e6a2 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -2699,8 +2699,7 @@ static void *new_vmap_block(unsigned int order, gfp_t gfp_mask)
 
 	node = numa_node_id();
 
-	vb = kmalloc_node(sizeof(struct vmap_block),
-			gfp_mask & GFP_RECLAIM_MASK, node);
+	vb = kmalloc_node(sizeof(struct vmap_block), gfp_mask, node);
 	if (unlikely(!vb))
 		return ERR_PTR(-ENOMEM);
 
-- 
2.51.1



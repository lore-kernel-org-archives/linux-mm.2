Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E805CA1013
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 18:13:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E30756B0012; Thu,  4 Sep 2025 14:13:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E07FD6B0022; Thu,  4 Sep 2025 14:13:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1E966B0023; Thu,  4 Sep 2025 14:13:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BE1CC6B0012
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 14:13:05 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7C7401DDBFC
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 18:13:05 +0000 (UTC)
X-FDA: 83852364330.19.B16A05F
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	by imf26.hostedemail.com (Postfix) with ESMTP id ABE9E14000C
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 18:13:03 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=aisle.com header.s=google header.b="n2/Syx4s";
	spf=pass (imf26.hostedemail.com: domain of stanislav.fort@aisle.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=stanislav.fort@aisle.com;
	dmarc=pass (policy=quarantine) header.from=aisle.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757009583;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=SayrWq9EL+FzoaA3kSfms075bKzR1bTUIuxyks0UhpI=;
	b=cQ/AhMRHwwHZO0xbTQGy/OzHqRHniuFdjod2dTbxQJsl9S6EYp8Ll2NQypD5sb6SXIxbnq
	d5Y/vj7K/0JsOkQNPYv9yIizC7fLGRfSyxcWjet0G57S+fd08sN8G78308JQjUrRkHZN5o
	blvvzzSTHRj6sAH3b8pEpX2pU0tbrdE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=aisle.com header.s=google header.b="n2/Syx4s";
	spf=pass (imf26.hostedemail.com: domain of stanislav.fort@aisle.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=stanislav.fort@aisle.com;
	dmarc=pass (policy=quarantine) header.from=aisle.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757009583; a=rsa-sha256;
	cv=none;
	b=c0VedI9oX6L6pWYJxnnYocH7dbPfw19hR2ySfr2B7jsrdHZJouPXkd7HF+KSK2b9ySbxJ2
	0IbCsxXdnhA3L2V90xYtvV/sDNe99k0l6E1UshGkM0pxpINf2VMMWOlqvtYaprCRLqX7LR
	VQHsvRGcTYRY4y3F8AokBjY7hKRl9ak=
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-61cf8280f02so1925706a12.0
        for <linux-mm@kvack.org>; Thu, 04 Sep 2025 11:13:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=aisle.com; s=google; t=1757009582; x=1757614382; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=SayrWq9EL+FzoaA3kSfms075bKzR1bTUIuxyks0UhpI=;
        b=n2/Syx4siIE1ctw9a5FAmpT3r7qXfnTYKEhnvI+4/fH/woiPtYqNnrvUJQ/D6bKwQ2
         F/C4/jt2HlbrLlM2Isb40O5ZLkNY456eRZ05744kHiTjLsQq0zZT2CG7gqHLKbCsYyj7
         xzX57kcnLmxRVmTAxK0dO7+2B9uVaH6hdCR+NnsZm4gjneWUaPd/1H7fCB/QIz9Prx4g
         9vNfcZjvTt8uMgwURFGf7GR+xlzvrQkC/Pi3hshh3+LmRdCJpUZENt/5bC1SG1YZk2Ui
         ZCbwkwfg0aaHmkRe4mhwvPLUQ4T3+BAdkmxPb1N0V/PUshI6Qk0Zd7Beu+gdzqhj8elL
         xCwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757009582; x=1757614382;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SayrWq9EL+FzoaA3kSfms075bKzR1bTUIuxyks0UhpI=;
        b=RquaPoz15B7IbjHvM2P5boQK6PUyXJdKfmCy6cFaOCbA3f/wTnW5dIlguZSLPCX2yj
         TgXr29wO36mGyv8WOw5FGkTOh4O8IambISGeFAh1GkpQd2Cc7MMyPNK3UU/BSMAqNkGQ
         jMYtVdQhztTLPipf0EqsRKGbmxxoCK4ZlwdaAKA+veo5pn0mJeuM9fDvv13kq51hBEKG
         BAVaBty07au5YwfeRcf6KFrWQqzsnWrqnqBYX0Tes+Q01k7+trtKkL4MpV/fn3tLz+3h
         mL2n19gnO4OXjvD3epdP2aWeEwRtJZCwh17VCuRlkwx+KM1/RVreLKel67UhPIGkcBdB
         Lvjw==
X-Gm-Message-State: AOJu0YwYcFofbI/6OVUzs4FZeUthP52kfc305x7KlYjz5f1pZp01mpOw
	VI3QaBKc9xCl7cnkRwLTpKAWEYWRymI6oeC6j6RGuhahnfuUnKem4ySfzIX7kijTPbjElR+OzUw
	qp2RBfuJ1lnFq
X-Gm-Gg: ASbGncsp5oxzepW+hqWxVw0IjWaq3Gsqm5NUFVe7KfQJbAmU7LAOW1g7X9ydyqcWl7l
	TVojqlPOBVSmpyJVgiv37Re84YlSdjEJfFJmuDp5vuJo3URCehw35SV4PiregLLJSDtlknbjj2G
	xW3dnyXc5U46/6dx0wBw+nL7HQLZK75Pb3+iikAB/am11SPjH6TjRB7t0AqumpZ8oSMMrlfnFxc
	u6qITAgvzq2aVriJTMyGjTzDwc7O+F3fBhkalqL3fcAVOk1QxKzeHOdMj6PKLlXAGaZefCo4Hm6
	+KjNZXO1ngAhKhV+G7Tkh6Fv6BfK60NtrhV8b/xvctcPGewA3vUD83Vazlk7h2CqJu2uPResIzX
	nt7t59FFzHsT7AFBD7xqo2uJUdJkcYhDrSzy026Ddr7q5Sz4b98uiQAoEBA==
X-Google-Smtp-Source: AGHT+IHUoe7GgAw674k6cHcnUO6jamtfXKG5fx/D6I4lzI1hf6rw2tZLSQ+zfPP4YmYrq1x5+ZhjMQ==
X-Received: by 2002:a05:6402:27c6:b0:620:bf3a:f6df with SMTP id 4fb4d7f45d1cf-620bf3afa52mr1230412a12.19.1757009581838;
        Thu, 04 Sep 2025 11:13:01 -0700 (PDT)
Received: from localhost ([149.102.246.23])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-61cfc4bbc51sm14408641a12.27.2025.09.04.11.13.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Sep 2025 11:13:01 -0700 (PDT)
From: Stanislav Fort <stanislav.fort@aisle.com>
X-Google-Original-From: Stanislav Fort <disclosure@aisle.com>
To: linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	akpm@linux-foundation.org,
	stable@vger.kernel.org,
	Stanislav Fort <disclosure@aisle.com>
Subject: [PATCH] mm/memcg: v1: account event registrations and drop world-writable cgroup.event_control
Date: Thu,  4 Sep 2025 21:12:48 +0300
Message-Id: <20250904181248.5527-1-disclosure@aisle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: pk1neotwespnk86jyaoq78txhn43cgm7
X-Rspam-User: 
X-Rspamd-Queue-Id: ABE9E14000C
X-Rspamd-Server: rspam05
X-HE-Tag: 1757009583-716564
X-HE-Meta: U2FsdGVkX1++hkeJF+HCbdTRSS9S/GgWRJ/NjisvsoXdgZqT0qaOKPdt8mXyjJOLyQ5rTC7a85R4WeQfObjLhB2pRw02XmaZiGMRJuWJcZKq+Om1JAP1BSYwF3zR4ZYepM2oAPIx/qdzbxPY3vUolbARew7tV8OdxL0soznLm0hRIZj6dfAf8AKSGcqbh7CtJLYl9yJiZJHRlRUC/hJd9pR6QBmhNryy+9zbg7ix6Y8IlCBQbB8Ls0p7peINBh5Ky+iMsWMAQQqu40mPndlRnlvDSNOTutH947TI0nva3xvQjbAHzuRrbmPk10APyMWujHMpwRPK+QMtsXOD7z8ehRN8g5qG9zz+je9gitJk9kY7UqpxnoAkAZ0KdYOELzrEWmnRfbJQuQYXxgZQZlXQjL79ZzdsPvFPBBc3K7ceNQa/89rgJo1rnvRhwUnySMsmttwaqTtUBuhC69ZJko3wP1XDSzxDFOHH3epI6mZTv019CpQrHx4suzBs/MohH+bHaHmon4urgodCw5Bh5rBii/9KXtwMsQVWrsC+HIzaZjBdMFPmpoJfxjW1XnjewXhcERxp9MeUx6kR7wHhVe6tRW351CB67VHXD36rh/O+ikMAHD7DmQSM+azWrJ8+gq0uAJpsrG18/jZ1KgDDHUtAiUy6+hVGDUun4aEJJFBuf2wuSgOVcXYFKlhjtFWpi7eM1zRRNo+n4/BDXEtnvN4HV9knJueUCMjDEMaI+XsCX0Q9AQY1jvKE5YCalZjqmkbofavmNpSX90Lwg6PLx+9PlnzPKdgAd0dAGISeEYolMduBs1qKGQGy2sikjViY6QzPzTazRAmSZCiFGWuaz/JjiBTH7Zneva7AVzVVhZkFEuxkseI/KxazhXbQaBLL15K1T4JZrVKcdEB6gVNI6NvTw2tWezVKIjZI6OiK4zwfR/iJmtTt5NbrbkeqZazX6vOtQIC54WWhLs2AJ/kgbVx
 omvoRC8P
 neYqeF20LtxKJgAMnYHvYy2/gybSIXd3y3UWTQduWR0NdkJTs+zp0WXpH8G7GO++pXsVGU0x/6SXWqQ0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In cgroup v1, the legacy cgroup.event_control file is world-writable and allows unprivileged users to register unbounded events and thresholds. Each registration allocates kernel memory without capping or memcg charging, which can be abused to exhaust kernel memory in affected configurations.

Make the following minimal changes:
- Account allocations with __GFP_ACCOUNT in event and threshold registration.
- Remove CFTYPE_WORLD_WRITABLE from cgroup.event_control to make it owner-writable.

This does not affect cgroup v2. Allocations are still subject to kmem accounting being enabled, but this reduces unbounded global growth.

Reported-by: Stanislav Fort <disclosure@aisle.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: stable@vger.kernel.org
Signed-off-by: Stanislav Fort <disclosure@aisle.com>
---
 mm/memcontrol-v1.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
index 4b94731305b9..9374785319ab 100644
--- a/mm/memcontrol-v1.c
+++ b/mm/memcontrol-v1.c
@@ -761,7 +761,7 @@ static int __mem_cgroup_usage_register_event(struct mem_cgroup *memcg,
 	size = thresholds->primary ? thresholds->primary->size + 1 : 1;
 
 	/* Allocate memory for new array of thresholds */
-	new = kmalloc(struct_size(new, entries, size), GFP_KERNEL);
+	new = kmalloc(struct_size(new, entries, size), GFP_KERNEL | __GFP_ACCOUNT);
 	if (!new) {
 		ret = -ENOMEM;
 		goto unlock;
@@ -924,7 +924,7 @@ static int mem_cgroup_oom_register_event(struct mem_cgroup *memcg,
 {
 	struct mem_cgroup_eventfd_list *event;
 
-	event = kmalloc(sizeof(*event),	GFP_KERNEL);
+	event = kmalloc(sizeof(*event),	GFP_KERNEL | __GFP_ACCOUNT);
 	if (!event)
 		return -ENOMEM;
 
@@ -1087,7 +1087,7 @@ static ssize_t memcg_write_event_control(struct kernfs_open_file *of,
 
 	CLASS(fd, cfile)(cfd);
 
-	event = kzalloc(sizeof(*event), GFP_KERNEL);
+	event = kzalloc(sizeof(*event), GFP_KERNEL | __GFP_ACCOUNT);
 	if (!event)
 		return -ENOMEM;
 
@@ -2053,7 +2053,7 @@ struct cftype mem_cgroup_legacy_files[] = {
 	{
 		.name = "cgroup.event_control",		/* XXX: for compat */
 		.write = memcg_write_event_control,
-		.flags = CFTYPE_NO_PREFIX | CFTYPE_WORLD_WRITABLE,
+		.flags = CFTYPE_NO_PREFIX,
 	},
 	{
 		.name = "swappiness",
-- 
2.39.3 (Apple Git-146)



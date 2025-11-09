Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3742ACCF9F8
	for <linux-mm@archiver.kernel.org>; Sun,  9 Nov 2025 08:45:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FD228E0010; Sun,  9 Nov 2025 03:45:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D4918E0003; Sun,  9 Nov 2025 03:45:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E9FC8E0010; Sun,  9 Nov 2025 03:45:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 57B398E0003
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 03:45:03 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A54C7BBE46
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 08:45:02 +0000 (UTC)
X-FDA: 84090433644.14.1801D20
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf26.hostedemail.com (Postfix) with ESMTP id AFF35140009
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 08:45:00 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="NYoly/bV";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of swarajgaikwad1925@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=swarajgaikwad1925@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762677900;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HXrwwoVC//E0UvQ+RFUnyKxTxBHKV/pNmqkF20wMo5o=;
	b=RCpD0oIZ3QD5u9gPW5Qi2oqN2456EQ7HpuEH8mTgP274z+iWMM78emKGxIjaO7QG9kH5WG
	DOmp90b5osIHwKFoL4wD25OUisB+/xg3SPWXZGZhRxVuMINQPZ8mLGJNpyREgJniHQGBaG
	xRXiRsjp2Rsn+O2yrQKtQnllgd/xAF4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762677900; a=rsa-sha256;
	cv=none;
	b=49GHS3iOhcLGJY74H1dkdR0nxAuT50K8RAjmv/Q/Zlh6cjb3pybuWRYmKupUlAxVTP8snb
	hmnpT89ybcNR8RkLFtfFomujfz4S721hJ8zrmjHVp3Zrly0QSA/uGb8f4cSk22/qiOYsQ5
	WIVECD5nY0KY06jxQ5opdXHL//lPmtU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="NYoly/bV";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of swarajgaikwad1925@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=swarajgaikwad1925@gmail.com
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-7aace33b75bso2188283b3a.1
        for <linux-mm@kvack.org>; Sun, 09 Nov 2025 00:45:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762677899; x=1763282699; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HXrwwoVC//E0UvQ+RFUnyKxTxBHKV/pNmqkF20wMo5o=;
        b=NYoly/bVe7pAfjaUWFm4T5fMVYw1sJCQKHTTWDQlMvUOCaiz6WlvuKtSGUUAkPc4RI
         zOBJ3B5zpnIhymBqgXswnysGxt6IOR4K6tR2zY09qwjVn5/1kKXQmhtnrolMq+HKekIv
         xlkeHQHHYafmK82EtoYm6HY9QV6Z+LCrLONoW0sLn0qysDNGBPLuiNox+5qXmNRcYJWq
         s7Yu6yeBjWSlOI7lyGnmX39Vf3TMQv7NFp/xFyd9VyYU6n6Ati0f5Gs/bIpMr4jloqXl
         4t/0kGAAh/pBFD2e1ypChEuF8Ow0Z1+kW2zxNsTxo0j0shXdWBY7ESTPwu471r4IiHPp
         M+TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762677899; x=1763282699;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HXrwwoVC//E0UvQ+RFUnyKxTxBHKV/pNmqkF20wMo5o=;
        b=NjxZZxRNUw6Tie8EDNbDJ2agXZoM+ir3DukU2MZJUoq5/tmOddih3QQaQ/lVX+le6a
         gnAIqO+xoRnrqDwNTyNG2IgSKnLBZ8crOAi2cfageToBw6q3JJsD6imCueFG4HIvd1eJ
         FVyfakqgnZ0eBkr7TVhO5WphR9FjjW5XRwJOpUfr/FIw3mmrgbPdGbWDVK+D7Cbzjgtk
         3ABN3ul4Z+gK5fL58RumIVlNjON5jZVlPPmRoBFX2uO0N8gI7dE7o93syQeX2Vgu8sk+
         L2L9N14mc1EUyQBHHH+0Ir8yWV3va7ZwVKJ6ckgnBRU36aWI+2BA0Z64zyZ9EqXa+MTt
         GM/g==
X-Forwarded-Encrypted: i=1; AJvYcCWtEeNN8rQb80GVMce9BK6ZnFKqgoD8uWslmL0AIRr+nwHd0h4WkhhDc6Q7UqqvOh/IKAgDb21hYA==@kvack.org
X-Gm-Message-State: AOJu0Yz7p45aXvseMOGApNkl5ZQsa7MI1sB5gl5hnG7Oo1vt4T0dvBZM
	g6kjXAUyEyuGSIR+7cVYnEgjoyPodFdL4Ldr5xIWzrxrLKO99tsXqk+5
X-Gm-Gg: ASbGncs+GShkGeKc/gmpZkIg15jYhL8Dx72CwGtImFNYstCDa4t4P/Bioy1vk3Uq/rU
	ke8/++cNOIVKTjnmZYY/Wv4ne+QYRuR9X2HIYc88TPX/A4N+vx98bRG64jj7mnAsQMqE6ypAwRq
	SIOrFunOlnqiDwlkrrycr+ZYCPg2L72j5Hp5R/zzb8DqyAPzXQa04G6kgA+Vtt38ZeQY2Jhv2Ik
	Fd4/J8HTCiMg3FtXH+MQK9A0/U36EnP27ZQGMC4gTTzH7ZJml76nvh3qvfVoIw1hDe4cQ50UDOC
	AFJzfKrgCEvYoRGHqn9VuHS2YKAShnf5myz3TCaa4nkL0eME+NsocQyIfsVm+3jqKJQkyY7V+BW
	ciDEqUx0X/ODqffmSlmEtqD6HPAV5Ih/45cg8YQjtQwSPVlOU4HLAwhKqvXpTsOQhLHFKN+0Wy7
	FHkxKSHguaRbQzNFZJo6c=
X-Google-Smtp-Source: AGHT+IGnp7pQv0Zxk4SgmB3b2rk34RXmsJWJfqb7o4EKPC0JwCRCGTVvM5tpZ3lAu6qeBHhvuniQMQ==
X-Received: by 2002:a05:6a00:138b:b0:7ab:a41:2874 with SMTP id d2e1a72fcca58-7b225b6e947mr5446010b3a.10.1762677899397;
        Sun, 09 Nov 2025 00:44:59 -0800 (PST)
Received: from LilGuy ([2409:40c2:1042:913d:b798:80c3:5bd2:24ee])
        by smtp.googlemail.com with ESMTPSA id d2e1a72fcca58-7b0cc863a09sm7917183b3a.53.2025.11.09.00.44.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Nov 2025 00:44:58 -0800 (PST)
From: Swaraj Gaikwad <swarajgaikwad1925@gmail.com>
To: dev.jain@arm.com
Cc: akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	swarajgaikwad1925@gmail.com
Subject: Re: Guidance on contributing to MM subsystem
Date: Sun,  9 Nov 2025 14:14:50 +0000
Message-ID: <20251109141452.7097-1-swarajgaikwad1925@gmail.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <cb17f29e-b45a-4275-ab2b-1443d909d944@arm.com>
References: <cb17f29e-b45a-4275-ab2b-1443d909d944@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1g6u9z6furcdk8r3oja5t8d7ga11arxj
X-Rspam-User: 
X-Rspamd-Queue-Id: AFF35140009
X-Rspamd-Server: rspam10
X-HE-Tag: 1762677900-716565
X-HE-Meta: U2FsdGVkX1+/O3m4PNJmnqlFOj20cCPYS4RC8z7kaadvvAUZWvhOtnedqv3CorlZ/dCI4ZABAVHpcmzqZqu75Rf2afcrZEMP8xBlWIgVbwXesaHB9+XOOQLjjD6pWIp3XZSUEz0R221GZh6LN9vQlh5j5Me5l3EgklXZdua3ZxzGQ2BdF3d/pivfgKGqWClyKsBME4KMsUqnpFacWr9C+ii4yFpaoOj/StC4mkM5j8BqZujA966EevZGX2kI3hLh1hzvz27W6JrchsR7LdyxeUmTE0JwtDBkS1eSHbTV6mmFBC0iu1/aC1qoKVP2ttKcPl0vZAKxZuM76phTem0YILlFQHC4Y8dillmtdhYi2k3ofUuGfr8AUXG5tDkguVpyQnrFxwYcTlVYLHaFndHTxo4TeAdiGnCclJu3WKqtVw8EG/ljW++OVgw2uRjeGMqiApFq62WF8p2W0Y+G+trCXwU4OVbqU7c0yEyw8y1+vX4iwg4tc1UcQ9nSm4uhZ6Ux0fCV0u1Oc4JNgwHde4uKLUgWRmfvBcFPzn3YMk+4hS3lGNJGWLhg4n3cuF9P3VspJNrPy2Rmv4uTebfu1aOwJ5PQNR74t49DqaaeyHkysGq2iE6Krpa5u3gwsQVN9WqoLfMAFjNXHwhhwNMx3fP8WUpYswPQy2duEadQdFtx+hpCvUtQPFc9fekBhOJjK7snRaZnpp3jBSVYRXRowcHoBz+uasqrFgtPhiDlqCnGd998UpuHsgiNgbN8WdgT8By/AGVlG7e0FRtmkcV9HvYQJe0sM937y3FDD1JbwF+siox2Tu0ycwx9vzMluBv2qUXB6mjyHQ2hZVjqy2n/nUkjXb84GCnj++JULtNI+/ItXeQVIwnnN98hy34pJehH8XXEEwCk380GecIRGrNxZxGLzeglBrgKDd6HuOUCkwrJ/XPvgXGI/d5PdPYqcDZUy0HZa0j7aD3oIh5HNyCC96Q
 D1PKgeax
 MWimx6XjOpy3gDOZneB9s4MGZNkSC5Z9tuRJSELfazmS1caXLxZBkYKSJFhPydniVCFMAI8/vgnbF/Edv9UJ9M6a3g50ab3jtFnRp4zcAM+cwr1ZB9C52eWCrEcc7nsI9xwytVryCchiLeBfKRZ1ZCZOItC3h98xhvrZ2qavipj4HAENAujm/e86t7pSKy/mpwY/6Ku+yaQtUk0V1Z2S/Rf2RVk1FEy8BJ3DKQgrbS+ySMnoZhoeqguUVDJlVPMaoP5f98RVHcVLZPRszSChpxGomsAtQxfdzuBRbCfLy5WZTVLi9P7hT/ct+/vfrBsFZQqkJRLi1lTWXJGx/01YnbETMGaGkLdVEQcU5aX6FjGR9TBt48iOQ29NSyvlkKYbS5LNlww/X9b6Z75QxWl0B/EdItmn5u0QuHtatDPpWgt9e/7Ks9IAFwrFFpVopiE+LVWNE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Dev,
Thank you so much for your reply and for sharing your experience.
I do have some basic understanding of how parts of the MM subsystem work,
but I’m still struggling with how to find meaningful issues or tasks to work
on. For example, I’ve been trying to explore various parts of the code and
read through documentation to get a better grasp of how things fit together.

In other open-source projects, like on GitHub, there’s usually an “Issues”
section where contributors can easily find bugs or tasks to work on. In the
kernel, should I mainly focus on exploring TODOs, adding selftests, or
improving documentation (especially for new or less-documented parts)? I
also believe branches like mm-unstable and mm-new might have ongoing issues
or regressions, but how do developers usually find or detect them? Would
simply building these branches expose such problems through compiler errors,
or should I try building with different configurations (for example, using
defconfig and other configs) to uncover potential issues?

Even though I’m beginning to understand how different parts of the subsystem
interact, I’m not sure how developers usually identify new bugs or feature
ideas to work on. Once I understand the code flow better, how can I
effectively find such issues or areas where help is actually needed?

Thanks again for your time and guidance!

Best regards,
Swaraj Gaikwad


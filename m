Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CDD1CD5BAC
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 18:03:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E6AA6B0096; Thu, 21 May 2026 14:03:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 596F46B009D; Thu, 21 May 2026 14:03:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 486F96B009E; Thu, 21 May 2026 14:03:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 344BE6B0096
	for <linux-mm@kvack.org>; Thu, 21 May 2026 14:03:42 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DE61A1610B7
	for <linux-mm@kvack.org>; Thu, 21 May 2026 18:03:41 +0000 (UTC)
X-FDA: 84792199842.22.7856561
Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com [209.85.167.182])
	by imf20.hostedemail.com (Postfix) with ESMTP id 0CF661C0008
	for <linux-mm@kvack.org>; Thu, 21 May 2026 18:03:39 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=LdedukKn;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf20.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.167.182 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779386620;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=34C8fXNm/YEiBjxD9RvPlzx1E/TAl0M2wZPpOGsYjno=;
	b=jtBqocqAPM41abWCTlUWOYgceSK5JKGLaTYNualotpHIRpJwernJkJB8R4IGlEVzqNPTLL
	EkGloKKos4+0f7TmpnmJz5tImnn0CIVO9K7CjLgN6eZ1dGd/TXuKJgAENuf4P+hL4CW+6R
	L9FP8QzvrKtLT2d5/SubxABlwAA0GhM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=LdedukKn;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf20.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.167.182 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779386620; a=rsa-sha256;
	cv=none;
	b=vZG1yUYldpepWO1jsRyW/CzY9B1spesolWNEDJKSryOoG7tZ6K8+Djf+82aR5Bh+cro6Aq
	VdGQdJF/UcdUljg6KXKsWZNZV7O0kANy+pWJVs6H/ujcECWH/wSnmQBKM9TsxYZwmUAz+e
	VDfvzv/tvJLraHAZrey73KE1VCkZu64=
Received: by mail-oi1-f182.google.com with SMTP id 5614622812f47-47c7b282d73so4217101b6e.3
        for <linux-mm@kvack.org>; Thu, 21 May 2026 11:03:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1779386619; x=1779991419; darn=kvack.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=34C8fXNm/YEiBjxD9RvPlzx1E/TAl0M2wZPpOGsYjno=;
        b=LdedukKnBwxOOUjJKL24J90N2AqHHbghd9LZsg6yCfSHtBnRhTsdpZ6UESodmR2+hn
         oEroq6eG9OqOjWD6G3XAK+KUderAOYZyfEMF/oZf0eGOVBsm11a+MTETu11s+kcVnRHh
         mg0GbYHvC8rEBl423b2rO/Hd0C/gOgdypqtyH/PG3Qxxshu85ZmiuUpraQo4NPysZALu
         VY3YjCpCsr+01E442lIEFTtrgS8BRhlKgci2HKjkIy01pXByuvrc+QXcExhNhOm2D5f0
         99qkOKMUixa4RLg/ZOqzN2HOBxS1Qn39xG+wbsnbWuHS54YnNzORPP6DeLEYk+gvnhUA
         yYdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779386619; x=1779991419;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=34C8fXNm/YEiBjxD9RvPlzx1E/TAl0M2wZPpOGsYjno=;
        b=iR3dp3itDNs7epcqCW/QuH6AjkCbpkaFGt05BbuDz0ASmv5IP+DOLv7gBFlwUJV7r1
         WcA0y6rtsjY94h7A0ggwvDRDm0uUc/3zI1JV7/P7mYFXBCFZmWwo0AMcNmmzERVw7bgt
         6/RORA//tdA2Mv2CumXfSIznMQ9AmbMurwy4YQvCp+ljEUHFyz4nJIjH13ZWt9rOFbD+
         T+o2/jyjNNSvacgkcNMIXvB5o63tXXdtpKh7fiXrMfBs4rm4BGOuKGhd2GAkbbn1XUWK
         Pf+HktUDfKbq7kz0b/ay2EzU24OmcK6ZMAVb4bJfhq402MFfEL6LPFy396+O6B+jBGW+
         QU2Q==
X-Gm-Message-State: AOJu0YwFzkbTCrmQWSAyJVvs3aAHj3vZLXskvnwtL01e9CqYEMQfbfkg
	EMxyDdNqZQbuBNj4dsmDJAhVSCxrCuogC4VL0weZ/Wo/o7B/hqyTZZwpI0OVlceCpPM=
X-Gm-Gg: Acq92OEy/QEwxin75dI0wnZLOi0SPlSdvrjqYVGqCXFPxkWFXxcQveMqKsud3pLjbS/
	fMkPhS8pweKfPmBz/KeTt0zlxAOyiukeT7p5V4oZbwVbgiC71O2zylMAEImMc1yKyHw147rmYts
	RLHdEut36HWLlibnaN/45QMLEzme1HwMnwNEilo72U8VFBtW3QYAdBgOQWB4jj1b451SHZK5L8S
	NoW7SUtSwjNEhw0xz1p2d4j8PaJgL4GwsjvLp717dmkgYT814IETB76P8CUUPgtCsh4QcrKaWSz
	NVH0yPhQoOnAdJGsPDATauTYuZXjW+TP4KQCaIl644mNLvPHZq4EmP5hdtNa/nwtmC5TowF1ggF
	qSJJ3FGqJ68wqLIswWVF8FciLtZ/hqI0a04XMwh7y7r2flzsQLN5vkTGloI2HSNjTnLA+Bw9bOX
	oTYwVh8qJaffHgzl/lbgQUtS9a6MQbhOhCXLENlkuPz+m3rvm5WVWdm+hqr6QvYlA+6ao8qCo=
X-Received: by 2002:a05:6808:f8f:b0:45e:84e7:c20b with SMTP id 5614622812f47-4854a3b9b7cmr27003b6e.25.1779386618973;
        Thu, 21 May 2026 11:03:38 -0700 (PDT)
Received: from [127.0.1.1] ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-516ccf4c8d2sm12753751cf.29.2026.05.21.11.03.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2026 11:03:38 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: kexec@lists.infradead.org, luca.boccassi@gmail.com
Cc: linux-mm@kvack.org, pratyush@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20260519152957.548119-1-luca.boccassi@gmail.com>
References: <20260519152957.548119-1-luca.boccassi@gmail.com>
Subject: Re: [PATCH] liveupdate: document systemd support
Message-Id: <177938661809.1151612.9365895540077391794.b4-ty@soleen.com>
Date: Thu, 21 May 2026 18:03:38 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0CF661C0008
X-Stat-Signature: qqygdicxyx3zc8uom3cup6s8wu1sfgp8
X-Rspam-User: 
X-HE-Tag: 1779386619-432606
X-HE-Meta: U2FsdGVkX19Cr5r5zUoJrl4VDQDz8rlR39xnQDbGbLrZ1MBojz/m+MsEperEoGc7AMeBlg88IBJIgFQyH+xvhycAuDIl4ufVo7VWR2mNromkAV8D8hQNBImO04lRi+WdYifFf+jR7SwA+E8VI1JAtDPo54u6ElSAHi3cvyv6zJwet4JUaFR2yHP6CbwGCCvv3WevYlaRWgu6uFSKH35EuEg2ubPmdXnSY/He/w0WLtbreNPEIankek77eUP7LQKtA++MPxCOwUVSLQ7Q1J783b9qdITBw8efpNpc8ttv2dSVr44Puvi+1eu1xg/hwJPRUEreIR4qPcuWxfUd9I3lc3TTBGbQ1ErYPncdcn6KzRTOWfcfgUbyJn+Ho/IuXulRE79d6FRuwHX9APtR+PU4kotz6n0BlqxQ+0oDAHkFHakgUabssombRvmid28qHm73v2v+Hb/xVX8yFrlJ6z7rnp5Oye8zjkJumlNb/UGF9oOD9ztjmYxK4Xfo3BDvOMRPnEwNcjN46C73GrWkdxgF8pekGT87hRuAiKPdJTCuwCZ8Cry7M4Xu+V+o00mUJ3f8bZR1mB2Pf6ZfkTIbr/ZcylQ+YBM8hWm4Jl9/MJNDZEr7WL4ocDEMYq4rhtNibvTCsHXoKSKCLK4SYQ1iUtkR09oRUDOC0PhACkZ1k+biq8j9z8+MWUqbkLz066iYE7yqhjmkMoScCiJV3WOXq0TERw4eP3n78xiNrbGjYqUfDq0s1042WJkdgkoGKkMMoK532he1/439mz//jtkMj5F1upt5ucK8aHZX+gJop8DF1Pe7OkAypp8kXv91hM3qHcc2PuH2OiVHa8LparjkHLl1tQTho9zVWcZf13rki7XNd3+KXhSWxZLsN2f1M6G4ozmo7kgvbsn2u6GTqPIIg8pCx5dKkKAORMP9NX7qXjvzaKROBvYvxrMAg1Hw1CKpGZSo43s7O62aq/Iug61Tprb
 9i7+fzW2
 6pryjiYvP8wSdv3wA3Y0QWGq7DPhRrCOPdT23u4wUbnqKQI0o1Slzg2eeN/rBxWrLZ9rIUsn2TbQOKy5L69n6UCtNjNShvGMyge8l4RLISsLpFWE2FqzInwmWubPx0Sr7MRip1T6u+3VkwPAb1nfSomya14H5TMA1UJLTmLiDrmMT07gfZbyv2hOpHLFBz7rVZJxdzUfLSzAyK/2/GvHoqhwo0oCfCTgR6+j4H7XuUktGYLALavbyDsGpf7bkqoKMvQMUiWJeVO/1J9zJ2KgyP5HQt2Wbp+i0K480i+C2fJED5U+u8jQAT8XmudUpn9No/3uaF5VbUV3aRxpGeYw/WZzLNuRYGRtyS7rsrDkgKKds01/nfgJDETacArC8Ko39OF5rMNZWrEKQuPk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Tue, 19 May 2026 16:28:39 +0100, luca.boccassi@gmail.com wrote:
> systemd v261 will add native support for LUO via the file descriptor
> store mechanism. Add a brief paragraph in the LUO userspace documentation
> page to inform users.
> 
> 

Applied, thanks!

[1/1] liveupdate: document systemd support
      commit: 1b7ce86f23a430ac91a2ed6cd88046e16751b285

Best regards,
-- 
Pasha Tatashin <pasha.tatashin@soleen.com>



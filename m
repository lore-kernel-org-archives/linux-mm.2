Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4AD14CDB479
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 10:11:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35CBD6B00BD; Thu, 25 Jun 2026 06:11:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 333856B00BE; Thu, 25 Jun 2026 06:11:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FE6E6B00BF; Thu, 25 Jun 2026 06:11:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E51036B00BD
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 06:11:41 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 627C140660
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 10:11:41 +0000 (UTC)
X-FDA: 84918018402.16.286F482
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf05.hostedemail.com (Postfix) with ESMTP id 974F9100011
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 10:11:39 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=buIBgmKc;
	spf=pass (imf05.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=safinaskar@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782382299;
	b=a/rBqxGPJ1yGWbbqoakR3tkX90gXexTVvbdzHbkWV8LxhthguJAkRmR3yFJJ+qVWAJISlH
	dys4wYBoWEjYDAGqakuiWYDuN2o38zuT7gjEzq9bGdFsEsQN9CmmR4YUQmGHy0vB24sc3J
	zG6DrO+uLcwCq1oo8tSX5Uz1pQHT4Do=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782382299;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ELq4DcsgmxsG/xQ7iP6tdp51y3PfpvNXYbA2lrH5JcM=;
	b=ltcNnCkDKsArYkE3WjG1bIwDfdzqzhSVFBbcAQZSCow4Ebk17kvr7UVaV02PXWIJ4vOVZ9
	Ryudxc9YQwSkpVWy7aKitZuQxgotVt6290Ljf8lXv2t3qehFWFBzz9/wgWmI5Ska1VzPbN
	ch2iw9s8Hl/jU3uCx1EdPzkXnvtWT08=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=buIBgmKc;
	spf=pass (imf05.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=safinaskar@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-490b9318997so11245865e9.2
        for <linux-mm@kvack.org>; Thu, 25 Jun 2026 03:11:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782382298; x=1782987098; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ELq4DcsgmxsG/xQ7iP6tdp51y3PfpvNXYbA2lrH5JcM=;
        b=buIBgmKczzKRkySy8nUllHXCQgxM0diyO3yJ5JydyXv5rw8dXmDAjU8Qg6T8CdEwfE
         mMt8jWnntjA3pvKcOVC/HDjZbqXsF+H8GIMC4EShHX8RQ4LuWL483fx6rXSmfiF3j3T7
         qkR9Vvrk/Ods8lWr8qkjHqS+14wAYDifZZSz+645eBxpzTSM5PFJAPNZEAFjRF+T6RR0
         3syXwGVQHRtoPQlUmd0j7M6DSu2wJZl03D0pMQObvL3G1LcmNGTihe/0YPnRcubODJwz
         ykpY+RFJTgVkXXjfz5EA8qpEGpC547YJz1/vztHeNASr6gbyHz07WvzTCgINKZkmyS15
         84Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782382298; x=1782987098;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ELq4DcsgmxsG/xQ7iP6tdp51y3PfpvNXYbA2lrH5JcM=;
        b=qBdVpIwvF2N7KrrxG+K4NL9IKmwd/WXAUEdNCMzhOv9FGS9crveqg5206jtW8xXqh7
         xhIlb03BjxxxkalyPwd00iLTteSIFG4vcnV3QhyxgEsq+jUMyZG1uci+OFoIyUXxO/jG
         8Oeff7SopiHnq71jkTknXV0D7u8QFNGon5je2F7Q6Ep6eokayBFdc5I7zMi9D7qPuiVW
         d4Kirc0zAur6/AGj+CEX/g9cIPntHXIvByFpRCe+/isqmmpGgh1ni2OVWETQ6gfL94dT
         D/PpJjfDj3lH/JWqxqP5UuWwx040Q0D55GmCioAy3hirzevbcYxAqUTNWP2VyX+6MrpD
         cnCA==
X-Forwarded-Encrypted: i=1; AFNElJ8IsjIQ1Ca6mQLYg3LgsWuN3nhVhLxwWn8o2bgnzIqlZ2CRH+xbF4YWPbE+4TwzJMCP4BoLxUlpSw==@kvack.org
X-Gm-Message-State: AOJu0YxAa3I4E+lR+QBRla7Msb40+lHj5DqPmRtuSnwe/SmC4EZrIt+h
	2SNC6WUf8VWmbJWuyFNGUdl3AaWcq+4b9RTCvY7Tm7aDvxhZlNdfQsIH
X-Gm-Gg: AfdE7cl1j8llPb3gK40nLLHn1L9G1yU5hpyGXdZzaX09BRrI0jXgeEbG8J/ZMFIfg0N
	gVVe+o+74vSvSEI8oO3HrtaHpcJWRJI1v4Oj3bWhoRnlVLqf70GbElLYmMxofUxuLgEL5sDAj7F
	axpuqRXZTWbHcPPqMqwxEYAhgTOr0qO4OiYDymEDu9RjUkRK+IYb/5zO8L0xu+EH13KIGE2tnKP
	+B8ifIXiQepW+PEQIV1gFXRfklBBNEhUxo2VpJsLGtIkfB+MJGcn/P0P+gqzREilmFAt1OYATmo
	flbxsrVygMNLg/SeQFJYboRrR2Xz8eFMjX5CXBqKksyvg6Xv5gxSDDOIpECKYo18wlFp3YV4LjE
	Hwrt5WFtcp2JFqojNN4TTV8S1jd8fAncVBeYwK+C2gZ8xJ2MKs2sP0n5aoXIUq6Myz0QeWKHtq8
	U6/rKI4HGR
X-Received: by 2002:a05:600c:8b53:b0:490:9d1b:f086 with SMTP id 5b1f17b1804b1-49266864977mr24965995e9.14.1782382297752;
        Thu, 25 Jun 2026 03:11:37 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-4926417f0c7sm59950125e9.14.2026.06.25.03.11.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Jun 2026 03:11:37 -0700 (PDT)
From: Askar Safin <safinaskar@gmail.com>
To: david@kernel.org
Cc: akpm@linux-foundation.org,
	avagin@gmail.com,
	axboe@kernel.dk,
	brauner@kernel.org,
	collin.funk1@gmail.com,
	david.laight.linux@gmail.com,
	dhowells@redhat.com,
	fuse-devel@lists.linux.dev,
	hch@infradead.org,
	jack@suse.cz,
	joannelkoong@gmail.com,
	kernel@infinite-source.de,
	linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	luto@amacapital.net,
	metze@samba.org,
	miklos@szeredi.hu,
	netdev@vger.kernel.org,
	patches@lists.linux.dev,
	pfalcato@suse.de,
	safinaskar@gmail.com,
	torvalds@linux-foundation.org,
	val@packett.cool,
	viro@zeniv.linux.org.uk,
	w@1wt.eu,
	willy@infradead.org
Subject: Re: [PATCH v2 0/7] vmsplice: fix some problems in my previous vmsplice patchset
Date: Thu, 25 Jun 2026 13:11:32 +0300
Message-ID: <20260625101132.3859505-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <89ea76b3-e956-4232-8180-ee3929adf905@kernel.org>
References: <89ea76b3-e956-4232-8180-ee3929adf905@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: src3865qymuhk54jayggfxi71k4ubxjp
X-Rspamd-Queue-Id: 974F9100011
X-Rspamd-Server: rspam06
X-HE-Tag: 1782382299-973511
X-HE-Meta: U2FsdGVkX19dFVBI12vexp4UPCEXzF146YBApuL9ZcM7tiaj/2VfMjPZShdCUYMnMt4+Sg1A+k8ysSfcr6z1xohWZbpNoVZiGSbEC4fDKlbG4dEe0QXMeLe9hsPSblVN9W1NPqdqFlTCmBhpb0/TLj73943TseXQs2RVfXC3CHTQNDEFjAjJ3+2zDAmYEYhe3c2/7NJ02826gY7+PhdQCVf2l6cKlBECec/KkfT1kc3CWD4eQwHfpzU3jF/weT2GrocYYcofharqqPBoG/6gStI+JLLAcdpFueMzDusnRbqETBAcJqFHehJ0qGSkaQUBaBL9T+Iem1bFrKkGREIKIBvJY5r79BvbXyo2K4X+zabQfO/KrvVNy7z2HUh8XMQbp+lQDoAB1FXyf+Uddg23/TP5rRnd8qgR8mCknjRgmXhSulULkBvaIEFW7hY+kbpymbr0bv3d/laXH/4pS5wYeLjPnMavFZCSzLx8YvGmph14NEwatNjwgWBRyV3WxW51SrxHpkwq/6bYOCV0DUQpmGTF9j5ACLs1+GUbXNqSZXQMBQ+iT93hV+qg1P7vWw936yPACHs4HL4cnKlTcs6jbyzTsSLa9k8my7SRVquI9W7IOO4nezYwtqZviJtSwHrN9K3FmH2rPPQYhPdYGyLc6k4pYA+wZaDnMzg1Cpy21gHVtrABeIIqheH+E5x0P729VL1xC2f3FVX4GCPdRS4Goyoms9OiiGUX3tGqZ4bqRpNv/be8b/IOKcnNZOvICy5JpKoj0J9eHnZGBDalI+6wM3SY/Wc92VSnBQd4pvoqPFKf76+FIkQ/UxqFRp8gtqZwWswmbXw9dqPUT555WWR9+wePR2WHnFNYAz7XKOdfPTUo2EQvKpVhFdJAiceRiZHMICZUpfvn+dJxOfWYOxgpg1F+8rGLmGhIWW2dc0Av6526Q2/KYFStMNnS1vZI6gtT8hkGrjvdoYt/ELhGthc
 Y1x+KOjs
 wclfNR6/Mb1YO23EYuOHSOhabK634zBOAIJZGEpN/4/OGLoe6JbRvJcRHfushmmRVlkmMBf7TEuXCs2WHUk/rrx0Zg0evM1aw0idPZ7IwxLKWtlIuCdKUMvKQnCBFPvIyzYAYjIN0v4lZbWmFG5toEvK3xwpexRzZPrO3ecbc9VaPGz8om+CVZDHqmskfNJZgDUpy8TcNUzZn56aQYiRg6kWt6yvFWkv4LQXSIA6IU0cdVw1l44HmqxJItLE/hbYxZXrmDL8e/qQvnp/BSIBHqBYCdCSHO9yoRzKN5nm8I2ohyLDIGnEl657WyCSLEZYRwkmienbL+2SfGwzmZHYtm1i6AhhR0QKhEz+f1pcr1hYcg6kxQgs4uMHdJs8Qiu1JrONWzDNx65HlUHepA66XzYPV8oaKpTd/W7xzbVqJEqIKOuKFc66VMFB1lgYEzw07BFbCHrfvNa6CtNXlZOsm5ProoqTBPjW5osBnRIW/yy0DFVD/MceJ3h7xFg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"David Hildenbrand (Arm)" <david@kernel.org>:
> I think we concluded that we cannot rip out vmsplice that way at this point, and
> I suspect that Christian will drop that topic branch from -next after -rc1.

I think my patches still have a chance.

On fuse regression: I return EINVAL for particular combination of
flags used by fuse. This causes fuse to fail-back to non-vmsplice
code path. I did Debian code search, and I found none significant
packages, which use same combination of options.

So I think I was able to deal with fuse regression.

On CRIU named fifo "Not supported" regression: it is handled.

On CRIU major performance regression: it is NOT handled. But I still
think my approach is right. (See cover letter for details.)

(I wrote about all these in cover letter for this v2 patchset.)

So all regressions found so far (except for CRIU major performance
regression) are handled.

Other option is to introduce some deprecation period (as
suggested by Andrei Vagin). I can do this, if needed.

-- 
Askar Safin


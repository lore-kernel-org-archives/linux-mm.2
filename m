Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 173EDCA5FCE
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 11:51:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB10D6B0088; Mon,  5 Oct 2026 07:51:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D626C6B008C; Mon,  5 Oct 2026 07:51:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C51536B0092; Mon,  5 Oct 2026 07:51:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A2A786B0088
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 07:51:00 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3B7FB1A0219
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 11:51:00 +0000 (UTC)
X-FDA: 85288406280.18.E896F0B
Received: from mail-pj2-f43.google.com (mail-pj2-f43.google.com [74.125.227.171])
	by imf02.hostedemail.com (Postfix) with ESMTP id 793798000A
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 11:50:58 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Yq5tNvvP;
	spf=pass (imf02.hostedemail.com: domain of donggeunyoo.kernel@gmail.com designates 74.125.227.171 as permitted sender) smtp.mailfrom=donggeunyoo.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791201058;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e3CuOM2eCvGmHoYcmlFPplrZp0K02m2jIXVmvukgLTM=;
	b=Ki9YwUnVbzU0KY0lzn2c8+KDWIjd5poOVlaSlmtypgwoarCSCnmkdlXO5dWf2T+9VAIbEt
	lRO7DKv0vD0Ec0n06WGzySJRt9jSpeU6FVv3qmnG8SjOV3uw0mlBMGEw02yGglE6qfP5qt
	ZTX74b0sXDLbIy1hIzlK3zvAbUQXMeI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Yq5tNvvP;
	spf=pass (imf02.hostedemail.com: domain of donggeunyoo.kernel@gmail.com designates 74.125.227.171 as permitted sender) smtp.mailfrom=donggeunyoo.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791201058;
	b=z++PEjYhJ9xZPZ6ULye7uk7TG0pYwJMniEoMPvbaL1F/br1DIi3pwp2pjm+Cz1jfh80Lk2
	PhzEgnw9u6ryKA7UnU/eSEEFwxzqTPtEIWt253ZiL4Y5WAfjh/A1OV0z4v4XPk7eroBtQ9
	s9nahnagLcbdqWIo5OncEYJQu8989jM=
Received: by mail-pj2-f43.google.com with SMTP id 98e67ed59e1d1-39b2ad83dc6so1002388a91.0
        for <linux-mm@kvack.org>; Mon, 05 Oct 2026 04:50:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791201057; x=1791805857; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=e3CuOM2eCvGmHoYcmlFPplrZp0K02m2jIXVmvukgLTM=;
        b=Yq5tNvvP+1/9wfVfboP35ch8SiwYDZL0NoZp6rIXbjnMMXCU/V8y57vNw3REthsc1/
         F4l1A+LPu3Kq5OzYKSUR5ZIC0tv0FM1sFNWGE2u2UOWEB3S0Nm/7a9HRzhnoA9VdzMAS
         B8xwHxNJLsGynq3NsI55JKh/aFL8fQDUwS7gaTXNuT4k/k//xR7smtrnrHB0eR5AY9u5
         VDTiSRrLGGnQzlmSJiYyCtot/0dQN8Bm4UkQhPglG6ayWjmhkQ/UGmh9BksuzeFJqP49
         I4kHpSqljZ9LB5PlJmlBTkH4mUOTxUTDCpTCu0YNvBidWIVRn50RJ8TPOo1Zf4wruU+2
         A0rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791201057; x=1791805857;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=e3CuOM2eCvGmHoYcmlFPplrZp0K02m2jIXVmvukgLTM=;
        b=iKJcnrXwhKYlhLb4Tln+dP5jb4JMGoullOb+vR3ZjTNpcpbXiYrK4E6AqntACDg1vf
         WQc+PeeUgAZjPYGXsIc/ut61uQBvJ184XTWM2lxsj1E5utn6Z4pJug+QzC8Z9710FfLY
         lxILbbJr7XCo3CEtVGJ+B1alB3/mrliUbC8QZvNubMb0ynfOwZuoca8dKRIpRsyUKhns
         7qBBluZJuTFXnxJ/GGil57Ut/xGXZNyT7T6sujM/GFSvuFeXudIhGu/YbN/NQGpZmVRt
         Rz1LRBU+bMCE5hEp0nGnsNCUuDcMXKCzr9DTHaFs509BH3aduTjdnHIpVf7E7hshut6d
         eVKw==
X-Gm-Message-State: AFq9FYJAz5RdovvCJrgadrHmKf2kAenjvyDc/7pRTJmoBggaURQ231DL
	kr/AAaQdTw7/ElKdWMuxJ0edj8xpxX+jUajh8p87HlUidh6fCxFbDETZjv4dhAs=
X-Gm-Gg: AYBFou0tdtox83mlEHunSE4EBfOjyLhSkTz0jMA+YeZGG9sKpgwyymGw0dlYvfIsWJR
	Sw0GLRahbc5/TrNHQw6Mw6hRxek7OYeAAkibwa0h7Tb4mI6pDrIW4saNoRAAkOrcDtrkEUukQbX
	ifYPZaxIrbP88/iXZ/EB1MsU91kIq5Ytoolk/UgF+fRZxINsUYs0MmqJ6RRAkyF1ZlgNqpL2Vsj
	/afcw40qsg9UBHWpWKdMf8WS/hLo1A0Nh02eTayc1ioIjX6Qtb8J30baOR5YVuLVU53ou69AWqk
	p9h+J5snENBvdJ2ab5pp0ZZl87ucYzoYmTwubf9vYNsqHww5XXxV521pY52zby3SqZT9tfKvl7U
	r0tzYsctZLMbkbOT73Fm1zemCA0pV0luWhSfTZEnVnVj5RQSShrhUzM3ZfWE2Li+JalzdNUFUd8
	kKweEfGHuJZlQORgh3PjGGcWtvqVgC2pq4+2GpKI8gFjzgnovax0dJqkfAtrzLFCOtTmUUJdGol
	XLJhYMKxcLYN08jjYcpf3RHzpM=
X-Received: by 2002:a17:90b:17ca:b0:3a7:f45:5cbf with SMTP id 98e67ed59e1d1-3a70f45678amr6816057a91.28.1791201057185;
        Mon, 05 Oct 2026 04:50:57 -0700 (PDT)
Received: from ydg-Zenbook-14-UM3406GA ([2001:2d8:7102:e8f6:be5c:45bf:9b70:944a])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a78e4262f0sm11942752a91.4.2026.10.05.04.50.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2026 04:50:56 -0700 (PDT)
From: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
To: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: peterx@redhat.com,
	surenb@google.com,
	aarcange@redhat.com,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	mhocko@suse.com,
	shuah@kernel.org,
	kas@kernel.org,
	donggeunyoo.kernel@gmail.com
Subject: Re: [PATCH v4 2/2] selftests/mm: add tests for UFFDIO_MOVE of a uffd-protected swap entry
Date: Mon,  5 Oct 2026 20:50:51 +0900
Message-ID: <20261005115051.3950585-1-donggeunyoo.kernel@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <4a24f7b1-65f7-4947-a325-7c9e9f642f2a@kernel.org>
References: <20261003103030.63380-3-donggeunyoo.kernel@gmail.com> <4a24f7b1-65f7-4947-a325-7c9e9f642f2a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 793798000A
X-Rspam-User: 
X-Stat-Signature: rr1q3cizapudg1ojxwcsrguhhgaqt1q6
X-HE-Tag: 1791201058-481517
X-HE-Meta: U2FsdGVkX188/HAKMUYjAzMBy0t4Dv7sJAch+RJpRrN+9JomAvU882CzFk7Cm/ZTd6JY65/Ljj56ehHq8rKuYoXb5z60Zi8NzYS2dJCvQPCpFqivxrPRPX/Ravmn3n45AOOfC1qyvwfao4N4OHBmmuxZ6X9tvaDjaLomyjeNFTKSiFm0l2Olp1NujtbQuDRHKRx4+szgyufvAlCj3t23vTKCozD4eiwTGXnk8DiDweINisv5xx2z9CDAvjUnmFOqPYX48pD0z2lOBT5YScDyBNjEqW9n4RzK5jmgGjyPZSxAQkK55OKoQYevjhffk1B8n9DG8GYkaWKcUG4IHHwT1Ne21d6caEU2xJpFPvV9spDu4ysg/1oZ3Jiz2V/xDLJbwNHeWizUCcFUwrY/q3kplhwZQ3jvIOWefFeEN4QioXyxDxmhKxORrxqLxbXk6DecTzJaWwPCyeUhwWsyhHLFkYyoJpb/rJkv255wWgDhHyWafbxG/PMgE6k79xBxIf2D7FhdBX2neMcYh24VKpTCYzuWQwqQZTIufIbF96B1ALoAhX1MGgHWfno1iQWl9Ha/e2n39UPiJymTNwLnihMVi01V34aSLPZ6bbX0lQ6RQtWK04RJiVQgwzXy62YYgDjZKw47PNW4GTEpnWf2BNBNPfCMAsw1j5pu888q34kU2wdu39ydOmBfZjzt1IwDof3RPHhq4QeKXnlmunQn6l+mfsTyMeXAHpmrKQTtrwq1YwWGOxI79DbGnvPiFVDbAmkNSHIInHof/dIgq3zpak2DQzFT0JJG7QdEQLZOgepfs4gQKmNLAYWppmHKKrH5shbmcC28CWrelvyIUP+ynLW5XILh3s4RDV6k2MQuGy1fRwczBgF7nQCyJ4/AzRBfYrGJcKUuQg5m5sb4TMlgBnRsARx/3DmhBhKZ7k6axZniz3miigsA6r2Qgto6p6896NMqbFDyKuSs6vMOWPmJj7X
 V4WKlROA
 uzaF4icTxGi0pQpQRH4KtLIDKwyYRNoDRWzT2HHa0EFUMG3gNi/J/aiu9feUjcD8ijIGlHJhO2C6e6q9ODn0wm0JuiyvBHrBELXuUnPwfkZxEkQV1mSkzq4sYMtzdc6O+cEsDAtzKKgjSNEovZeFr5mVgYVqV8BQQex3Hlm0zss+9v/+TnCkbfxarFQurfKN5WSgArjPZApCG4knCD/cBhpmpS/y6/f8wTkOa2C9Bk4SEkwZ/QyK7AAPTv4DrWrwAKezMCbTtuNiEmhGkGg8aQDg2iq1yiMtUsMd3dC3sakpnYO1J+ttSyBIO3OUB2kqh5E1hh7S4+ZSVZsra9S5nBk9mevLBW4aNdqSytJkLoELmJP9HAaFi8NbqrPQx7PPp4HihAhZI1cDl7zJjrLho7eZ/zxFT9osQjTFkHgAHpfXuPo/ve38ZF6RA7tqYCigdRAp8VM6COOw3MlB76nIiyL2mwcykSb/YJM8RtDvndIdEyR2g451+2TnOEDMuh43GlzzNJ15hZ0CtAJZTr7MFWjsB6axoLeQqjd4SRV0A/pSAIQcV6Pn+hHBGjl+T/RltOpUQZ7J5hI0MYrpV9M66Br58cQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 5 Oct 2026 12:43:48 +0200, David Hildenbrand (Arm) wrote:
> The CI complains as reply to this patch:
> ...
> ✗ userfaultfd(2) test failed:
> # not ok 43 minor-collapse on shmem

Thanks for passing it on. I couldn't reproduce it here. Could you share
the full log of the failing run, or a link to it?

Donggeun


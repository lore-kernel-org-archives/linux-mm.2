Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B19FCCD185
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 03:58:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B34B78E0005; Sun, 12 Oct 2025 23:58:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0C458E0002; Sun, 12 Oct 2025 23:58:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A48CC8E0005; Sun, 12 Oct 2025 23:58:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 945C58E0002
	for <linux-mm@kvack.org>; Sun, 12 Oct 2025 23:58:31 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2357A1192D7
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 03:58:31 +0000 (UTC)
X-FDA: 83991734022.02.77C9C90
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id EE97F1A0007
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 03:58:28 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WzBOQ4xG;
	spf=pass (imf19.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760327909;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lFkd7LDNlKxd5KdrHyin4eRIfcHDDgib75Cn6noGM5Y=;
	b=6Y2jEgvcYV9iW9iTUZxCF6KGy0rMcFD62R+LwVDfIT5cNTZjH3+nyAch9mcm9avyRVNfcB
	sRrhVTh6sryAXzvgq9QeuVV2ySaN3tMYB7i1P43C2MmWqJLnHX2utJQ+ZDgsMnEO+sOHIU
	zzE1+nSVoo8DI+R8HOFk6IiNeWG4kZI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760327909; a=rsa-sha256;
	cv=none;
	b=RnrPlPj8p2KxkMmqDSF+KAVtQJjBFGCzDb6yuL1jPXbuiIsvkwMrzA9WN9/pWAhqgMS3kr
	QUI6kSH8JxOBPKlDB4FakUYTtoT1MLgPstRRpI1sYE+8WDoOS8LRB68cGZkuf3WYPBr109
	AIRDAZgbM02t8BMl0QwaGLM52ZuoFqw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WzBOQ4xG;
	spf=pass (imf19.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760327908;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lFkd7LDNlKxd5KdrHyin4eRIfcHDDgib75Cn6noGM5Y=;
	b=WzBOQ4xGxuw8CeExV+L9aXxmvd7ZJ0JkiAfknHvJ/Qgg+7EoxWLiiS+edJgUePMDltI2pO
	v3YCv2f3U2o6jchNnOtEqqF5WOYpczhNEBlAVrnyKAV+RQHpCjhicHdvjCerbHBis4GCPl
	RwH7HcQptPvy7Xxuy03UgQHfPhjGzd8=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-395-JZ92hSzBM72hkBzeUbrFOA-1; Sun,
 12 Oct 2025 23:58:26 -0400
X-MC-Unique: JZ92hSzBM72hkBzeUbrFOA-1
X-Mimecast-MFC-AGG-ID: JZ92hSzBM72hkBzeUbrFOA_1760327905
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 771071800451;
	Mon, 13 Oct 2025 03:58:24 +0000 (UTC)
Received: from localhost (unknown [10.72.112.223])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8891D1800447;
	Mon, 13 Oct 2025 03:58:22 +0000 (UTC)
Date: Mon, 13 Oct 2025 11:58:18 +0800
From: Baoquan He <bhe@redhat.com>
To: Barry Song <21cnbao@gmail.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, chrisl@kernel.org,
	kasong@tencent.com, youngjun.park@lge.com, aaron.lu@intel.com,
	shikemeng@huaweicloud.com, nphamcs@gmail.com
Subject: Re: [PATCH v4 mm-new 2/2] mm/swap: select swap device with default
 priority round robin
Message-ID: <aOx42iLkuyYqXBMW@MiWiFi-R3L-srv>
References: <20251011081624.224202-1-bhe@redhat.com>
 <20251011081624.224202-3-bhe@redhat.com>
 <CAGsJ_4y4CLu7qeHijhJtL+NDrehfiWpu9mtsVGxmn5rBy03v0w@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAGsJ_4y4CLu7qeHijhJtL+NDrehfiWpu9mtsVGxmn5rBy03v0w@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: U2deyQMnR4z_lLO6mrcg4gV3GJdry95VGvkHe6r7wUM_1760327905
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Stat-Signature: nommy6mkezoctu3ouud9iat3ifjf89ch
X-Rspam-User: 
X-Rspamd-Queue-Id: EE97F1A0007
X-HE-Tag: 1760327908-851514
X-HE-Meta: U2FsdGVkX185Jw/ll28wuepQAz4YlrQXbeDFbTJ1nMA25B1bjWQdkIx1QFgFjbJhAPELhvyy2fA3BKc4vWfewiV9dQDPUxTpY5lS9GJb6FBfMG/x/CUtaUBtmj+VgMvsmRva0+NW/CPbWu1i60a12OQPjuKrPivvE99cb/vkyjU4e5hvl53/YUY+6mGsrb8888bA3yY6mvAzAQvTWC+FI8MORYlvz3iN7fN2IeQL0eys2+aOGgjkSSZ03mynafxvmno46G2nqh/cyjRgbmG3no2TUsESLTygZpsWpMnEjnXoWGXsikq0aj3z5Qh0AGFqGZWbhaB5wHQRxnfpg45jNFkYpBMWasPrQ5yxGQTvYDl7jKHRaeCpmbhRqnT4JWvVg0KbAZCkjU5pLh4QiIW33yQXri7OdrTc9xcdor4cIJ09RBDfshFxsdqEB9oG0K1gLFCwNBtV1TIo4E1K/jrY2qXoGWA5Y8nhWE26cqVyNs2g9cuZZCAGkz0ZODT5vvxoKDvwv2la5guAzAM+AWa0/rzqbGN+xw1e1ff2nsqxTiJYX9gEQTGBiOwewl5/X8c90bIY2cCC/U4uktzK3SzcZZnqUAhVX7pT753Ovy1Cxn6I/asfdmxvzLoXvXJ9a/T5HfC1ZhICcBHNBOhojXhtuQNiniKaVkvfIX7bZD8GRPWP753+1PlYAqWxuduAqxZeFxjffL5eB9+okkiYL6kjXBmtbxPLfSQ2i7MJWOP/3somCbqTUU8Hf1/0OP8nV9gvDSL0Y7W4Jewos1Ak5W2DN18Yj+T5KJE9Px4AIZYgzlBE8EQECDL+VA9uNYweIAwQpMWl7rFiBiEBdGlzkPbnNLAbVs31ODMiZxO/h08etP08RKUnkjJyfkDWRR7fF3ui9cS9s5zowkwNmmPh2T101P5//Z692AOx0vhtCaxLNAtKC0ygwL0Tq9JaNvK+EGTzH9UTnTuTE1ZTwN8dmXI
 dVTjfPXT
 dIOKMw6dUT8SsK2i9GBbPXsCMwKKBbplV4CpSeeumIEtODaeaF4+rTV9EzusYZJTtZv4CnjVyo6INtd68J2HWj+z8rV0p7FFRqvB1BC0haECqOSjmNeRioJ99TDRTmenCQxuB5MnknYzPY6D5Awb2WWQCWPp5NKTOrxgh9lLetGYmx5v0dIMWDK/l95wYYuTTMh7btQPNB2g6GztQ1MrNtQ7VJlY66s/pDip+A8a4oarLvFzxxiSQ7qFVP3PjckaSuXRfP3JeSb7OAp6NsQNejpZHlRYdmTRNJLkC77SGZ+45ssdHd9X9+Uwsw4YQ6jB3YMJRUaKrCjHT6KF4sHQLN+ATCOP/WwUGxcBaD3LlwBkvNy1G8mI3R0xqkqusPxyN+OTYBvXwpLjBemZsZcovN/jyZgegLNrmG4Lcjg+4DiuIsjiR1g1bxxnNMplxz8oJDDJbGWN6x8xJsGwRdqhQeOBzMgMnOTLWqUegODIIWY7ojJmReooLal7aEA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/13/25 at 04:40am, Barry Song wrote:
> On Sun, Oct 12, 2025 at 5:14 AM Baoquan He <bhe@redhat.com> wrote:
> >
> > Swap devices are assumed to have similar accessing speed if no priority
> > is specified when swapon. It's unfair and doesn't make sense just because
> > one swap device is swapped on firstly, its priority will be higher than
> > the one swapped on later.
> >
> > Here, set all swap devicess to have priority '-1' by default. With this
> > change, swap device with default priority will be selected round robin
> > when swapping out. This can improve the swapping efficiency a lot among
> > multiple swap devices with default priority.
> >
> > Below are swapon output during processes high pressure vm-scability test
> > is being taken:
> >
> > 1) This is pre-commit a2468cc9bfdf, swap device is selectd one by one by
> >    priority from high to low when one swap device is exhausted:
> > ------------------------------------
> > [root@hp-dl385g10-03 ~]# swapon
> > NAME       TYPE      SIZE   USED PRIO
> > /dev/zram0 partition  16G    16G   -1
> > /dev/zram1 partition  16G 966.2M   -2
> > /dev/zram2 partition  16G     0B   -3
> > /dev/zram3 partition  16G     0B   -4
> >
> > 2) This is behaviour with commit a2468cc9bfdf, on node, swap device
> >    sharing the same node id is selected firstly until exhausted; while
> >    on node no swap device sharing the node id it selects the one with
> >    highest priority until exhaustd:
> > ------------------------------------
> > [root@hp-dl385g10-03 ~]# swapon
> > NAME       TYPE      SIZE  USED PRIO
> > /dev/zram0 partition  16G 15.7G   -2
> > /dev/zram1 partition  16G  3.4G   -3
> > /dev/zram2 partition  16G  3.4G   -4
> > /dev/zram3 partition  16G  2.6G   -5
> >
> > 3) After this patch applied, swap devices with default priority are selectd
> >    round robin:
> > ------------------------------------
> > [root@hp-dl385g10-03 block]# swapon
> > NAME       TYPE      SIZE USED PRIO
> > /dev/zram0 partition  16G 6.6G   -1
> > /dev/zram1 partition  16G 6.6G   -1
> > /dev/zram2 partition  16G 6.6G   -1
> > /dev/zram3 partition  16G 6.6G   -1
> >
> > With the change, we can see about 18% efficiency promotion relative to
> > node based way as below. (Surely, the pre-commit a2468cc9bfdf way is
> > the worst.)
> >

Thanks a lot for reviewing, Barry.

> 
> I’m not against the behavior change; but the swapon man page says:
> "
>        Each swap area has a priority, either high or low.  The default
>        priority is low.  Within the low-priority areas, newer areas are
>        even lower priority than older areas.

I didn't see this in man 8 page of swapon, while see it in man 2 page.
Means people may feel that change when they call the call swapon()
syscall, but people may not cares about in script or something like that?

> "
> So my question is whether users still assume that newly added swap areas
> get a lower priority than the older ones?
> 
> I assume the priority decrement isn’t a stable ABI, so this change won’t
> break userspace?

Hmm, I would say that this will change the assumption, BUT I don't start
it. That assumption has been broken since the numa based swap device
choosing at below commit:

commit a2468cc9bfdf ("swap: choose swap device according to numa node").

Before commit a2468cc9bfdf, swapon behaviour is taken strictly as the
man page states. The earlier the swap device is added, the higher its
default priority is. And the highest priority device is used up, then
the 2nd highest priority swap device, and so on in sequence. Below
swapon output demonstrate.
===============================
[root@hp-dl385g10-03 ~]# swapon
NAME       TYPE      SIZE   USED PRIO
/dev/zram0 partition  16G    16G   -1
/dev/zram1 partition  16G 966.2M   -2
/dev/zram2 partition  16G     0B   -3
/dev/zram3 partition  16G     0B   -4

However, after commit a2468cc9bfdf applied, above behaviour had been
changed. I can give an extreme example, imagine on a system with one
NUMA Node, node_id is 0. Then I swapon several swap devices w/o node_id
value (namely node_id is -1), at last I swapon one device with node_id
0. You can see the last one will have the highest priority to be chosen,
then other swap devices.

So I would argue that if people realy care about the default priority,
it has been broken since 2017 when commit a2468cc9bfdf was introduce,
and complaint would be heard since long before. While we didn't hear
complaint, means the default priority doesn't really matter?
> 
> Or if someone sets up Linux assuming that a newer swap file will only be
> used after the older one is full, then this change would break those cases?

Hmm, it could happen, but I doubt people really count on that. I would use
'swapon -p xx' to specify explicit priority to make sure it. In the case you
said, swapped out pages will be swapped in, it's either not guaranteed.

Thanks
Baoquan



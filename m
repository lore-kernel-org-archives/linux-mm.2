Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B24ACCAC598
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 06:13:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9F0C8E0002; Wed, 17 Sep 2025 02:13:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C76D58E0001; Wed, 17 Sep 2025 02:13:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8C5A8E0002; Wed, 17 Sep 2025 02:13:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A8EE08E0001
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 02:13:00 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4776A832CC
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 06:13:00 +0000 (UTC)
X-FDA: 83897724120.24.A564A9E
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf19.hostedemail.com (Postfix) with ESMTP id 527621A000D
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 06:12:58 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=hi5asorW;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=EqiZa9ds;
	spf=pass (imf19.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758089578;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cm3XQGuNpzvU7WALjJ302177aZpCGUI+/SYqtjhnqvQ=;
	b=D2nfcMYLbbdis6H7+F+q/sp+waO0sKhaCjywZfFoM4EWxk4kyXzSVLdGb8cJpHQ1xhf/cm
	c5Gj9eM4Vui92VIK6pDQJ6wcVO/cASuvvn1thnpU9a0qllVVpX7FqL7rjwXlYWJcDDK9hO
	dbQ0Q5fcEwGdGBIlAghtUijj1FQbJOE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758089578; a=rsa-sha256;
	cv=none;
	b=fPKxxDVh0dyao/Og3mRQ11d9Mp6aO+QXF5rCXLQyAQ/ktx5K/hUpq9Nu+uflRiPEJLUtn9
	JrlBJr/HuTmdlW9AcMFc4g/0dhxZlrQjcVGhCJQ4eT252fDQsmMGdcvZKWV+21I68gLzSa
	mtzYDFz3QDtUAe66l41FnbJeAcvdacw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=hi5asorW;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=EqiZa9ds;
	spf=pass (imf19.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
Date: Wed, 17 Sep 2025 08:12:53 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1758089576;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Cm3XQGuNpzvU7WALjJ302177aZpCGUI+/SYqtjhnqvQ=;
	b=hi5asorW0MRa0dJUiGIVlulXm0HVRXsGvMegW2ksiku98PwZ+5SQkpK4EhEFxBA30Ticru
	VoWEaVThVfaWZ05ur8DwYDgb0zguVvgVCv+x3ZOiQ1M15ekXNcHozqZAtYyonBnPO1gVbx
	/vBak0GAB7lM29zCO5kjNdbtcs/FN3wmHd1QxjhyQcxtXYC8cRMz1kCWUDtD9vff7htuIf
	iF+Mp/E495zzQv5T+TyHWkchwI/Xs57SFU1m6WFhmymBtB44pPH+cgfmY5HRQQKNdY4CB8
	LyXh9vQPpdxhhXE5EU/jP9MLwBNHLigHwSbiGjhL4Ed6vIajEldeL2YFtyOfbQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1758089576;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Cm3XQGuNpzvU7WALjJ302177aZpCGUI+/SYqtjhnqvQ=;
	b=EqiZa9dslwzNdZAl+jHOf2eAEfjiihQFIsrRguyTUV0X3CkAj+r5Y2yP6H1pD1ri4GoF6I
	GPxPX0wkIIfFf5DQ==
From: Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: forward declare struct rcuwait together with
 rcuwait_wake_up()
Message-ID: <20250917080725-14901c66-b02d-4d81-8a42-1283333d3966@linutronix.de>
References: <20250916-mm-rcuwait-v1-1-39a3beea6ec3@linutronix.de>
 <CAJuCfpE-DPBp-0b0908FHvguSo_PqxE2LdUXvBiMLu1UCd5icQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpE-DPBp-0b0908FHvguSo_PqxE2LdUXvBiMLu1UCd5icQ@mail.gmail.com>
X-Stat-Signature: t6hso5kw4fu4zu7gtgzcowqtr1jq97dg
X-Rspam-User: 
X-Rspamd-Queue-Id: 527621A000D
X-Rspamd-Server: rspam10
X-HE-Tag: 1758089578-926669
X-HE-Meta: U2FsdGVkX1+w+gUE9x1sUy2iKVuAhSRWJzZSBdJQnZ4XyBoUdauMehQ7uammTQ2TJBazJ8JtsvlBGTIj8IM2dWmzP3y/x2DEfw8sOgBQbiaYcdvwi5lfCXit0w+a/gU006Qy4OEMmLvk0nXECF4ADquyaApc5ZMjtlAwVmb3jbDhJXO9/yB9PDi4CImimquudrG+Kmk5Ui9ba9vNmjy5IEvUMa/1VKNXEhhV4JidWcEt8/4rMxfEcw5EP0cwL9lIjtgl7Hp2vKBAgo3VCPJYa2LhaqCN5TXqCqVGvjkbuNWmNiFMgS7TGmH8eFuCsEONCQy6NUsAsghyCXvd1dmyyGuQn7Y/p5epFpY/xH5tU/bWzj4DpfzHsVVg7k62cgXIAVafvA9tSTsejA3BIan3v8zk97e35tey/DHfWnoezUPGXHm43PSivG7DyMXSLMukU4gnG4V+zvQ7JrECg1n2a334GQPT84iz0SXFDIAXAZS6q0K+tJu10f+a3codXAsTRg9eWxg04OVv31rFF16W9nJHzBcPr8JBzQJTs27Vtz9/L+IilDVSVQFqmienRnOO5dbqjg7UG6BYOV7fU2c5zCPT++s2bW7P3L9Trhcg5IbSeybg3G8RZhPvfEOl8dnQyGrsmS7kYmdNd3L+QiMPxmrzATivDx8IQZ+05Ut87RmKSL7I5Erq+oOCmKtMkMT7wpKkIpOc/5hfH2SCdL8exHpfBEEeRXAirIARuxnjcSrf6tYcyxfBR7LPcwCTfeO8Mb3NQwpLzKLcIUQncwYal1DmoMxIAS6r4z9PEoKRLuxdoYvd1LdEPDCDLFFA/BeltzYjWkER8oBSjHj/npINX3cNrydhFLBeoJx/UnpYC0WfiWEZ8xdByQjZmLBgwZ/sgmm7PaC1MhFbBoL+5B/sQ3ZojP1qES4YhITaMGrLyi4uM5EoR3WblIgRD5Y9GOVjge2LMyvTYqzXq2GAJW2
 A3O89ro/
 88xdENpvNbw0LBxL/+OokPbQM3VN33yrzcjfSfTl0yVjlUZEvNu2Fzvok5kF+akjk0C8ZjZ80BmxPcJcyK6PKTTBtLV4UBzlqdgvKL+2rOj4kNdwNd0l77WC6nwgGN3L51vaHyKzrmJt6wyul4bZ3wkobdYjJm7Y/gDZzW96cFi00x3F0X+PoFFMmiMSTfIojTAMiRqU0lBl+My4JdCk6a/LuLevHsEFdpfTWOKZsnf2/UhDHmxcnC21dCVhkq62zq/G3pknI8W6AYUaMro7Z0LgT0017yujnrLJW6wqWM9HMJCeFRc619olVzD7skWxdSbCIUqO8fxvM1TjFIxZbAt/SWKPZtUTMvKz+H8kzJweGFBIeQ+5ID36v/3aY9IxVLpRrjZ7e2ZvaKvwBZ/KgV2+fYBuA7UDi+LXc/Typ/cbSJ4UI/YOaSvijwszu+WdlZ3f0k8Utl1zHbDdjuhtY5Ip/xUSmAMPlbRLxxbuvu4XA2my4YiJ1F8G2fADIne1HWUHHWgJhLCn/MZ5DhgXx04K3pDfMVblAMRzhJMjzmbaMhx1/46jkRzRcscDg2T+0xK3O
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 16, 2025 at 03:04:21PM -0700, Suren Baghdasaryan wrote:
> On Tue, Sep 16, 2025 at 6:59 AM Thomas Weißschuh
> <thomas.weissschuh@linutronix.de> wrote:
> >
> > At the point of the forward declaration of rcuwait_wake_up()
> > in mmap_lock.h 'struct rcuwait' may have not yet been declared,
> > leading to compiler errors.
> >
> > Add an explicit forward declaration for the struct.
> >
> > Fixes: 75404e07663b ("mm: move mmap/vma locking logic into specific files")
> > Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
> > ---
> > This doesn't seem to break any in-tree code right now.
> > I stumbled upon it while building a series for the next cycle.
> > Instead of putting this fix into my series and spamming all the mm
> > maintainers with it, maybe this could be part of the last mm bugfix pull
> > for this cycle.
> 
> `struct rcuwait` is defined inside include/linux/types.h and
> mmap_lock.h includes that file.

Yes, linux/types.h is included, but only after the usage of 'struct rcuwait'.
We could also order around the '#include <linux/types.h>' before the
declaration of rcuwait_wake_up(), but to me my current proposal looks cleaner.

> Could you please explain in more
> detail what exactly failed when you were building it?

With the following change for test purposes:

diff --git a/init/main.c b/init/main.c
index 0d4510a7a5c2..7523786e6ad1 100644
--- a/init/main.c
+++ b/init/main.c
@@ -10,6 +10,8 @@
  *  Simplified starting of init:  Michael A. Griffith <grif@acm.org>
  */
 
+#include <linux/mmap_lock.h>
+
 #define DEBUG          /* Enable initcall_debug */
 
 #include <linux/types.h>


This is the error:

In file included from .../init/main.c:13:
.../include/linux/mmap_lock.h:6:35: error: 'struct rcuwait' declared inside parameter list will not be visible outside of this definition or declaration [-Werror]
    6 | extern int rcuwait_wake_up(struct rcuwait *w);
      |                                   ^~~~~~~
In file included from .../include/linux/percpu-rwsem.h:7,
                 from .../include/linux/fs.h:34,
                 from .../include/linux/proc_fs.h:10,
                 from .../init/main.c:21:
.../include/linux/rcuwait.h:26:12: error: conflicting types for 'rcuwait_wake_up'; have 'int(struct rcuwait *)'
   26 | extern int rcuwait_wake_up(struct rcuwait *w);
      |            ^~~~~~~~~~~~~~~
.../include/linux/mmap_lock.h:6:12: note: previous declaration of 'rcuwait_wake_up' with type 'int(struct rcuwait *)'
    6 | extern int rcuwait_wake_up(struct rcuwait *w);
      |            ^~~~~~~~~~~~~~~

> > ---
> >  include/linux/mmap_lock.h | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
> > index 11a078de9150df1beff4f0bfb16e199333767614..9792dd4fff0ff73829833aae8ea3229a31757d61 100644
> > --- a/include/linux/mmap_lock.h
> > +++ b/include/linux/mmap_lock.h
> > @@ -3,6 +3,7 @@
> >  #define _LINUX_MMAP_LOCK_H
> >
> >  /* Avoid a dependency loop by declaring here. */
> > +struct rcuwait;
> >  extern int rcuwait_wake_up(struct rcuwait *w);
> >
> >  #include <linux/lockdep.h>
> >
> > ---
> > base-commit: 8f5ae30d69d7543eee0d70083daf4de8fe15d585
> > change-id: 20250916-mm-rcuwait-03c5fe95f36d
> >
> > Best regards,
> > --
> > Thomas Weißschuh <thomas.weissschuh@linutronix.de>


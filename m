Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E09DFD232C1
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 23:27:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2546D6B0089; Thu,  8 Jan 2026 18:27:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D7E76B008A; Thu,  8 Jan 2026 18:27:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BA4B6B0092; Thu,  8 Jan 2026 18:27:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EB7E56B0089
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 18:27:07 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B0A7F1B13B
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 23:27:07 +0000 (UTC)
X-FDA: 84310384494.08.1B926D0
Received: from mail-wm1-f66.google.com (mail-wm1-f66.google.com [209.85.128.66])
	by imf12.hostedemail.com (Postfix) with ESMTP id BBC2140008
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 23:27:05 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=pMHcGWYt;
	spf=pass (imf12.hostedemail.com: domain of elver@google.com designates 209.85.128.66 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767914825; a=rsa-sha256;
	cv=none;
	b=3Y083iw711FIqz+q33iglfXwneLI1VGtoswCZmgCQgrSWmn994myT4d/kNG5rAeWQOs2De
	92x/9Nq+JS7x1NYy7u3iYvm+6HzCbc412CxmPSQVWD0h0m5E6A4AXBFmklyaOC+5EtUySm
	t/nO1SUTf5hFyXOmbcJAb2FSF6BvH1k=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=pMHcGWYt;
	spf=pass (imf12.hostedemail.com: domain of elver@google.com designates 209.85.128.66 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767914825;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VJVnWCv1er1yEKW3Zzjqu5S3R8api15dEl8a9iGdG3k=;
	b=fQ00INzwoTLBlEfq/RW5Kq5RB40rwSBpOyekXI7iUJMLqDUAaMopw6L7Tn7G34MbFU/WHb
	+xTjpOUVysTi/6jgf1WsgaqEeH+9a15XelA3+Iuk0FLpo8vJhuZlKSX+tonLR8f8rfk3xU
	VtS6M4s3shd3wBCd4AFsXzlNFkBERbU=
Received: by mail-wm1-f66.google.com with SMTP id 5b1f17b1804b1-4775ae77516so40876135e9.1
        for <linux-mm@kvack.org>; Thu, 08 Jan 2026 15:27:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767914824; x=1768519624; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VJVnWCv1er1yEKW3Zzjqu5S3R8api15dEl8a9iGdG3k=;
        b=pMHcGWYtluHwf5yUUINVMQDKWa32gCLuR5KxXshTJitfFUqLT0EOBlr9OkU9AsBt5n
         sh/UW4mvE4/791z7x415pARq/iNe8dMdU4g0XmbXFYoLzMVeTFa5CH2nozIGjtstl8S2
         Pk+Qg8joEWwUpAswDPqRhNhG4+/QIH6BweCGAlckUUetkEsCULlPr4F09gydRuSbYWGc
         KWyvE67YcZW+/DXIFcD/SDRD4gOdWRLDJrDVMTKPh0nTYvqbhQze4VcjPcccDwegvkkb
         XZpOCucqK0MN0gdq6lQI719IXGtc9GbzBykAaj+hj1bTBsv5DpUHizg5TTlHlE9mMIu2
         oFyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767914824; x=1768519624;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VJVnWCv1er1yEKW3Zzjqu5S3R8api15dEl8a9iGdG3k=;
        b=g0QUbGo9c5BVoWe82WCf+mm/Zp2GNfsiBjCGIkq0nj4yVRouFQLzv0S97hwnYy5Auv
         0xGzB6Q5G7prYpFJy3fXvrPTXvcnmcRQF3nEySSK539ou3Hm7uYbHPYURhoa+aIK0y+G
         IOL3dXsBu4GTMO6bFMFw2voubuftmARRq0QgdKy88o1OZJxHP/evZu2BKjA4nQ5UcFoe
         fL8wM7o/YJoJ+RmMPQ443PzZkA/iQr1TRKhLBNIR9nV3EgAjig1xaSoXVwfcXVDfGrEB
         Wh2/2lGwY17BRJgfRQUqKbwrLRk/mNwqmlOXxfe0PRi6cHQpQ5hPYUzZcBjX8XV8Q6hr
         syAQ==
X-Forwarded-Encrypted: i=1; AJvYcCXmzk7PpocxRv2RjTUOm3MV3ysnvsJDSieMjjhsUlVc2Oqf0Kmf14V/9k9aJxLwbv81VFvGLKMYaw==@kvack.org
X-Gm-Message-State: AOJu0YzXq7SA68eo75KMDHG1dCLjrS+AFJPcdPVW+owIh5y2qDNNsDqe
	ucQEl9x9hqGjb3eZrz7lw1VlTTG58fE4AV6iOk6m1Dz2EjGSmoF56vADR5lAZ63D7Q==
X-Gm-Gg: AY/fxX67udL1rmzapduWb8BtbSzNAe2+TjaT6NXnIeiqIooTQNqTVdUJOy92xp/an+1
	ZAmOy1sRjM+opMM5FdFZ/mxaUBBPUh85XYO9umnUv7M1iDeN3xIj5GbynNnyofzkuORmZO3TYye
	AwOmXL1BI8OowZrC2b/H4aIgPEVnuolCKtSi2//dBd/b2lM9Ch8Hh8ethkPFq+QKx8qZoRpqRDP
	aOC49aNB2Aqxia3atXS15zZfRiglo4/jtPtpWG4sl9M1XbBBod0BsUiX2ymVE4ykHicxOu4Fpy7
	wApL/upCR0XVbY3Jclv9a795t4Q6HBqImmIpWgDG35hpq0QLNPx+vdiGSqU74cxJ8AxmsMo/zUA
	0spMgew20WNmC++EGnpXikKoKReQ72cOxz0QTshTwYnWTKO2ZH1dtgidIa5NZ/pU4ftVOaH18uA
	t7IVuCjB98wrdFKJ8pWXXJ6NR8EEer2m2fO2K+WFV2NlGE+7ry
X-Google-Smtp-Source: AGHT+IHhn5oqqXEXdXppHSooBMMRAzilyWn+PndcRbByujPILqHWwWxt63fu3OjbgMJmLJjeeFi/pw==
X-Received: by 2002:a05:600c:4ed4:b0:471:14f5:126f with SMTP id 5b1f17b1804b1-47d84b41181mr100523185e9.33.1767914823835;
        Thu, 08 Jan 2026 15:27:03 -0800 (PST)
Received: from elver.google.com ([2a00:79e0:2834:9:384b:578b:5b8e:a6f3])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d871a1e11sm46386595e9.19.2026.01.08.15.27.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jan 2026 15:27:03 -0800 (PST)
Date: Fri, 9 Jan 2026 00:26:55 +0100
From: Marco Elver <elver@google.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
	Boqun Feng <boqun.feng@gmail.com>, Ingo Molnar <mingo@kernel.org>,
	Will Deacon <will@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
	Chris Li <sparse@chrisli.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Alexander Potapenko <glider@google.com>,
	Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@lst.de>,
	Dmitry Vyukov <dvyukov@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Ian Rogers <irogers@google.com>, Jann Horn <jannh@google.com>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Josh Triplett <josh@joshtriplett.org>,
	Justin Stitt <justinstitt@google.com>, Kees Cook <kees@kernel.org>,
	Kentaro Takeda <takedakn@nttdata.co.jp>,
	Lukas Bulwahn <lukas.bulwahn@gmail.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
	Thomas Gleixner <tglx@linutronix.de>, Thomas Graf <tgraf@suug.ch>,
	Uladzislau Rezki <urezki@gmail.com>,
	Waiman Long <longman@redhat.com>, kasan-dev@googlegroups.com,
	linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-security-module@vger.kernel.org,
	linux-sparse@vger.kernel.org, linux-wireless@vger.kernel.org,
	llvm@lists.linux.dev, rcu@vger.kernel.org
Subject: Re: [PATCH v5 10/36] locking/mutex: Support Clang's context analysis
Message-ID: <aWA9P3_oI7JFTdkC@elver.google.com>
References: <20251219154418.3592607-1-elver@google.com>
 <20251219154418.3592607-11-elver@google.com>
 <57062131-e79e-42c2-aa0b-8f931cb8cac2@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <57062131-e79e-42c2-aa0b-8f931cb8cac2@acm.org>
User-Agent: Mutt/2.2.13 (2024-03-09)
X-Stat-Signature: y6r61cwinmforwc983k68gak3csh4fn9
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: BBC2140008
X-Rspam-User: 
X-HE-Tag: 1767914825-267017
X-HE-Meta: U2FsdGVkX1+Xd3ntOYVnYTaIJq6ZgMBglsdORLAWlzyfxDyEltvpO+JohoGyTHop4WmS+TnfOLdLfdis8HzjIPFhUbgT5oMBpVTutqt7EA22V7x3yb5JLqB3ExtTXR3Ok6UpJiG6yameqG+d1hLdZlpQ2O+BMVd9jei+wt9keAFo51e1ZChiD4IXA6GgvrAPd4BC3Qej7PViLPzfdj/c0ll1pENFjHyoM0cJqpjLgjcgKwVG+vNY3oUVdDDqEFHjfWwmYmJE9iGek5zvMS+kBW02h4KPfS1M5VWwTSgk6XNXxWRhZ6eyJOAdB2TYQF4jsgfBjQX4WZhWXUaDxJ75doyaqGBqVTWpH1Q6je56SuCe3tSB34oTiqSWg69lPaFM9SAkot/IAF7+OJf6T9ZS+k4m6aZY7FVV9iabGaHOzq/nwJgpxmN0+JB9ArsOJq9RFeQRybhNRYFwWgn5N5KtQ/0fUfoeQ6nFrHv4WOc4AdgnDsWIRGcj9Kyes2qbscQz0EAsGbGYxB2YCszQzIStiOnD9AJVjXR1Xf2/bmZFMPbNIIGwZePORxZMEAyqJYRFJJ7aaT92VRJGWMWLNaWYkoY5jdEF410fyO6IM8AjQhCdB0cldS82+uaWwwbmsm/uCsIJXF020zCbUdYMKdwA8IW5XyBdfYrnAcKTR3IK9gbnaCGjhzGIGW5ycGfqOWLgnhJBcxaZn5WkKtdfSySbmO3mM3bANp7FgDGXJaI/ibiAd62OFSnhzx/HYpu5H4Rx6PM0Evzn0+hdBCourRHPnf99iNzQWqfM5wCXb/KiT/affMYjDfUZ6vBR1OX3JJjq7EoIiDbYelsmSz0NxBklTTjSTOC55SPXFYYfMHhFi3lvrnNrxw9XrwraT5AhJAjnWSo4jI2c8H3YGaryhmTJaBKEiWcM3YeQKqLuZlU/2tfdsS9i8NlWuOK+wrmBjyx/qMbvHnuh4DohuQOc5XQ
 JfSAWT2/
 oVZtKQa7RSnTUJ6hfXxtmZh3A0dCNbIpVBOFCoX4ghSQUzW6sjkepcvMCotYb6Y0FOBL99Vn/d6NXRX6XZl2+jNyu9YZpgrW4Os2ChcLLNDhcApFRY6/Txq87Vezfqmhcx8pW83EXS4f8FO42Iip6ouLJk1UOOk2Y1Uir610yyoFl1RJOmKy269ZUodQ/CE0PWFSUO1cABwQo7gkXv7Q2QSgUfMsyu3QfKCJhrrwOTDmu3DnxEWj8q+HQa0voc2jRXPrKATivvn4NT07v1QwS183cXJPQt+iR9n2D9Yb5AilL+mA+8XjbuqPH8Mrn/5o0rHD15uzQoIxZaXZdsc7A/kUYM4eKf7AuqXsYNq9YdtVnhTrKdwMWAaTTOFhmsaT5vfSGxaZSC/piF6PNM9xJZnSESTNHXOfuT32pkmGvN0g/icaVzZWWFGIYEIpIS9IRwNAFJSeROtV7ntRUWeb5U236PYxUGHgUvx/nZi3HRrNl3xHqLNwrZ/d8hA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 08, 2026 at 02:10PM -0800, 'Bart Van Assche' via kasan-dev wrote:
> On 12/19/25 8:39 AM, Marco Elver wrote:
> > diff --git a/include/linux/mutex.h b/include/linux/mutex.h
> > index bf535f0118bb..89977c215cbd 100644
> > --- a/include/linux/mutex.h
> > +++ b/include/linux/mutex.h
> > @@ -62,6 +62,7 @@ do {									\
> >   	static struct lock_class_key __key;				\
> >   									\
> >   	__mutex_init((mutex), #mutex, &__key);				\
> > +	__assume_ctx_lock(mutex);					\
> >   } while (0)
> 
> The above type of change probably will have to be reverted. If I enable
> context analysis for the entire kernel tree, drivers/base/devcoredump.c
> doesn't build. The following error is reported:
> 
> drivers/base/devcoredump.c:406:2: error: acquiring mutex '_res->mutex' that
> is already held [-Werror,-Wthread-safety-analysis]
>   406 |         mutex_lock(&devcd->mutex);
>       |         ^
> 
> dev_coredumpm_timeout() calls mutex_init() and mutex_lock() from the same
> function. The above type of change breaks compilation of all code
> that initializes and locks a synchronization object from the same
> function. My understanding of dev_coredumpm_timeout() is that there is a
> good reason for calling both mutex_init() and mutex_lock() from that
> function. Possible solutions are disabling context analysis for that
> function or removing __assume_ctx_lock() again from mutex_init(). Does
> anyone want to share their opinion about this?

Probably the most idiomatic option is to just factor out construction.
Clearly separating complex object construction from use also helps
readability regardless, esp. where concurrency is involved. We could
document such advice somewhere.

For the above case, this seems cleanest and also clearer to me:

diff --git a/drivers/base/devcoredump.c b/drivers/base/devcoredump.c
index 55bdc7f5e59d..56ac8aa41608 100644
--- a/drivers/base/devcoredump.c
+++ b/drivers/base/devcoredump.c
@@ -339,6 +339,40 @@ void dev_coredump_put(struct device *dev)
 }
 EXPORT_SYMBOL_GPL(dev_coredump_put);
 
+static struct devcd_entry *
+dev_coredumpm_init(struct device *dev, struct module *owner, void *data,
+		   size_t datalen, gfp_t gfp,
+		   ssize_t (*read)(char *buffer, loff_t offset, size_t count,
+				   void *data, size_t datalen),
+		   void (*free)(void *data))
+{
+	static atomic_t devcd_count = ATOMIC_INIT(0);
+	struct devcd_entry *devcd;
+
+	devcd = kzalloc(sizeof(*devcd), gfp);
+	if (!devcd)
+		return NULL;
+
+	devcd->owner = owner;
+	devcd->data = data;
+	devcd->datalen = datalen;
+	devcd->read = read;
+	devcd->free = free;
+	devcd->failing_dev = get_device(dev);
+	devcd->deleted = false;
+
+	mutex_init(&devcd->mutex);
+	device_initialize(&devcd->devcd_dev);
+
+	dev_set_name(&devcd->devcd_dev, "devcd%d",
+		     atomic_inc_return(&devcd_count));
+	devcd->devcd_dev.class = &devcd_class;
+
+	dev_set_uevent_suppress(&devcd->devcd_dev, true);
+
+	return devcd;
+}
+
 /**
  * dev_coredumpm_timeout - create device coredump with read/free methods with a
  * custom timeout.
@@ -364,7 +398,6 @@ void dev_coredumpm_timeout(struct device *dev, struct module *owner,
 			   void (*free)(void *data),
 			   unsigned long timeout)
 {
-	static atomic_t devcd_count = ATOMIC_INIT(0);
 	struct devcd_entry *devcd;
 	struct device *existing;
 
@@ -381,27 +414,10 @@ void dev_coredumpm_timeout(struct device *dev, struct module *owner,
 	if (!try_module_get(owner))
 		goto free;
 
-	devcd = kzalloc(sizeof(*devcd), gfp);
+	devcd = dev_coredumpm_init(dev, owner, data, datalen, gfp, read, free);
 	if (!devcd)
 		goto put_module;
 
-	devcd->owner = owner;
-	devcd->data = data;
-	devcd->datalen = datalen;
-	devcd->read = read;
-	devcd->free = free;
-	devcd->failing_dev = get_device(dev);
-	devcd->deleted = false;
-
-	mutex_init(&devcd->mutex);
-	device_initialize(&devcd->devcd_dev);
-
-	dev_set_name(&devcd->devcd_dev, "devcd%d",
-		     atomic_inc_return(&devcd_count));
-	devcd->devcd_dev.class = &devcd_class;
-
-	dev_set_uevent_suppress(&devcd->devcd_dev, true);
-
 	/* devcd->mutex prevents devcd_del() completing until init finishes */
 	mutex_lock(&devcd->mutex);
 	devcd->init_completed = false;


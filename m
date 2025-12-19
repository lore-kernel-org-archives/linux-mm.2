Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AE37D711CC
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 02:12:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EA566B0088; Thu, 18 Dec 2025 21:12:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96E166B0089; Thu, 18 Dec 2025 21:12:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8465A6B008A; Thu, 18 Dec 2025 21:12:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7297B6B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 21:12:27 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 26E196009A
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 02:12:27 +0000 (UTC)
X-FDA: 84234596334.26.D93E673
Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	by imf15.hostedemail.com (Postfix) with ESMTP id D2AA9A0008
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 02:12:24 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YsqU10pc;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of boqun.feng@gmail.com designates 209.85.210.51 as permitted sender) smtp.mailfrom=boqun.feng@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766110344; a=rsa-sha256;
	cv=none;
	b=wIHxf/NX53RWuc4Az8EyZUDMEtCThQ5uottvcK68VV5DkaVAYV7yccMyZCdbzvPjDDb5LD
	eTnTnmWZIvyDarQhvhgpuivZO72xYLm5DLy5o4fIywI1eYBiIZOVSaxKKZVuK2EjjPNJeB
	j53PxzJ4pQ3xdTGNS1p8CSWqUT/0dBc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YsqU10pc;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of boqun.feng@gmail.com designates 209.85.210.51 as permitted sender) smtp.mailfrom=boqun.feng@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766110344;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l8X/mpvTeafKM3nH85dScPT9I6f8OgbfxSkwYBazOi0=;
	b=rJvS5bVPaVWRGkWKpONz90pRBg567Z7SkhoUpL94VJPzPbVY3dUmhQQqoZh5cseB3aQwG/
	J9mbxmIn66TGp52f9jD79dpkQ1yp0G9PXPItlhO9evt2eXMoPB0IGFVc0I+x4GvDd7L67K
	0iSIR1HvPBtwz1adyC8dWaFrcJKi1P8=
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-7c6ce4f65f7so1125746a34.0
        for <linux-mm@kvack.org>; Thu, 18 Dec 2025 18:12:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766110344; x=1766715144; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l8X/mpvTeafKM3nH85dScPT9I6f8OgbfxSkwYBazOi0=;
        b=YsqU10pcWsQvRWLbuVziZF1l/RXeY6HMQJeT+AoIOVBScOyPLKmeTVJKgmIaWUnMw8
         xjcYNrxPUCgWROg8iOKZdXFD9OZGITxGAibKy8nduoBd6Dbye6X3UQVDWgFETDn6FSu6
         UtBO5ejn/bNItQXhu/+BA0heNsC57DoNvqfmY21zDXF4KfJ2C6bH26ok3Uxv5PdUqT1q
         KPulbHpihsJVgR8V6cWEQeTzIw8FTXZHvOemS7Tsb6aWw4YGEBjYAWvv46wxRwwJoaAd
         +FmHowlabglx0r4+dEA8GPMCDhN9bw5HFDqIv6/cCbNIZj9Ow5ZQyyttnyMmAQoNu73B
         T8Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766110344; x=1766715144;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=l8X/mpvTeafKM3nH85dScPT9I6f8OgbfxSkwYBazOi0=;
        b=ct9p+GRRRIlMkqn/6tPeUlkR7ZXCSkYW6U2vd4qP00Ju6pqemQd4csv/xRoocWvszC
         oQSfupYGLT8bonZfNqB2qATJA3qNzgip/AAHwSFW0w0HUYoDHhssOfgc90JHVDYBTxcz
         oDaTeQwstziteSx5UrGtMR7sbEVWdFnYJK/lgeTG9uWEiTnz3mTpcJvqXIBpU3jeM1Po
         hjiZAXiwudgVO0gkIFJgv1VQ+oqDC+fPz9WCWVicmxIxXkBZ80UDH/LjZ1roNPAbaEIi
         0oAXFcRU54byomMcTnwYiEd5eC7I2rGFKlS95MtaPU2CgTFMyOx3W0xdazfZ43jNeUw/
         81rw==
X-Forwarded-Encrypted: i=1; AJvYcCXLdpR/5Uumn2MLvnCa2FjCJ62oYD04K+2NKb2R/dFdC6D8ebVvwf6cWCnBr89Z7AfB0Mj4x9SDEA==@kvack.org
X-Gm-Message-State: AOJu0Yyw5N/mMR4w5Zq1xJsg/pp6TZV3z74ycoyOT42tbjDtvQivAoYQ
	hYgNo5hFZ3730ksNSlUqR3OBELWvGnsk+YhHcEtDXVHJ4wVGcunQ+mT1be4hbPk+p7Q=
X-Gm-Gg: AY/fxX4OxmzDCTjXukr0pP5nCgLnp8p+M531kh2TQzeJbHZGTPecsg3ZsVB1oSIwEak
	V06RL09q5W585iBOt7NDQ563WtHa2uMgW5mOqCRwUUM5qXF8zIgNTnI/k2op5OYi4rdS+NExG4Q
	lRAD3Wnf9JLNZQUfq0DCvnsRTQIvuSLRwRf6a/6+A7xHFBeaIWMlu/P64wY89G608iadh87zqQ/
	6hAC+IdSQwif0KF/n/DOrpFwWHboA+TUkgMxzBYom/OUxL1ztxUx2zAILemAw5qt9M75UzI6PK+
	86+JR5Msnt454RxFm3yQfKA+EWThZQ28eCBmhhOQqxFbOMvzMBUO12cgpci3xQF+Qr230aOeFo1
	Z2Bm+F0TzJrfycL420/Y/bhuIk2ulLM96ZyV/+SNGM3eEgt+COdOpt4hecz/CggvbtsPspAEMfS
	2HQDzlCPLRojCV9NaIj4jf2o2F9ajoQFwPpjbEoF6Hply6aP8hxJ+EQSKKN5+UDzsUZBizalkq1
	BvyehadOfOZ8PI=
X-Google-Smtp-Source: AGHT+IFPk9sbtY0UjBkjpQV6F8R4ziD5cSSxeHmFqbLe73zBnLmXKITpnuraJGxLeqMdGtMo3KFVAQ==
X-Received: by 2002:a05:620a:31a3:b0:8b2:271e:a560 with SMTP id af79cd13be357-8c08ff218ebmr212306185a.72.1766103947460;
        Thu, 18 Dec 2025 16:25:47 -0800 (PST)
Received: from fauth-a1-smtp.messagingengine.com (fauth-a1-smtp.messagingengine.com. [103.168.172.200])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c09689153asm61478885a.17.2025.12.18.16.25.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 16:25:47 -0800 (PST)
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfauth.phl.internal (Postfix) with ESMTP id 25E38F4007E;
	Thu, 18 Dec 2025 19:25:46 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Thu, 18 Dec 2025 19:25:46 -0500
X-ME-Sender: <xms:iptEacwmTiy5gQQDNHuqeFNw1UMehNPtLtPloS2FK4zw_T7IuP0pEQ>
    <xme:iptEadbipso_0Eka7yXzgAi6XJaz-jPcJN-iFI_ptZl04YyVa32BWqYUVfkO2a-kK
    yeiDB9dIixeZUAo6UnQfl7MFBX4daeiTxJROZxPbMCrsTMK_4ZdeQ>
X-ME-Received: <xmr:iptEaezAk4hsYhJKhx6Bo4jiyentomcKy0hFx6cJFcHUVAVZkAxuKKDtwos>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdegieekiecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdortddttddvnecuhfhrohhmpeeuohhquhhnucfh
    vghnghcuoegsohhquhhnrdhfvghnghesghhmrghilhdrtghomheqnecuggftrfgrthhtvg
    hrnheptdetvdfgueetkedutdegudegfeekffevgeetleehvdektedvteeggfegtdevtdeh
    necuffhomhgrihhnpegvfhhfihgtihhoshdrtghomhenucevlhhushhtvghrufhiiigvpe
    dtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsohhquhhnodhmvghsmhhtphgruhhthhhp
    vghrshhonhgrlhhithihqdeiledvgeehtdeigedqudejjeekheehhedvqdgsohhquhhnrd
    hfvghngheppehgmhgrihhlrdgtohhmsehfihigmhgvrdhnrghmvgdpnhgspghrtghpthht
    ohepfeefpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopehmrghthhhivghurdguvg
    hsnhhohigvrhhssegvfhhfihgtihhoshdrtghomhdprhgtphhtthhopehjohgvlhesjhho
    vghlfhgvrhhnrghnuggvshdrohhrghdprhgtphhtthhopehprghulhhmtghksehkvghrnh
    gvlhdrohhrghdprhgtphhtthhopehlihhnuhigqdhkvghrnhgvlhesvhhgvghrrdhkvghr
    nhgvlhdrohhrghdprhgtphhtthhopehnphhighhgihhnsehgmhgrihhlrdgtohhmpdhrtg
    hpthhtohepmhhpvgesvghllhgvrhhmrghnrdhiugdrrghupdhrtghpthhtohepghhrvghg
    khhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtohepsghighgvrg
    hshieslhhinhhuthhrohhnihigrdguvgdprhgtphhtthhopeifihhllheskhgvrhhnvghl
    rdhorhhg
X-ME-Proxy: <xmx:iptEabitpgOdV036twsKZU0Fycl6cCkXbK3vjIo9wd515Tt2oE3SAA>
    <xmx:iptEaVoCS1HUuq-KUwu_2zsbMjT78TRhDzSL8FhFhZFtj5MppTtBuA>
    <xmx:iptEaSduPQd_Dp2na-hNNi9IVyVg2TOBkNp-qUAeD-G8wjy8CxuDfA>
    <xmx:iptEaQe9OnalWj9VorkrxBoBwI_xfWdXjz_dytDxw6x-9WH21ksy5A>
    <xmx:iptEaQd-Mnv1xhGkxUloFwEZrVKuaPvqUfZB7mcrRZgFvzSolvJbzRgh>
Feedback-ID: iad51458e:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 18 Dec 2025 19:25:45 -0500 (EST)
Date: Fri, 19 Dec 2025 09:25:42 +0900
From: Boqun Feng <boqun.feng@gmail.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Joel Fernandes <joel@joelfernandes.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,	linux-kernel@vger.kernel.org,
 Nicholas Piggin <npiggin@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Will Deacon <will@kernel.org>,	Peter Zijlstra <peterz@infradead.org>,
	Alan Stern <stern@rowland.harvard.edu>,	John Stultz <jstultz@google.com>,
	Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Josh Triplett <josh@joshtriplett.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Zqiang <qiang.zhang1211@gmail.com>, Ingo Molnar <mingo@redhat.com>,
	Waiman Long <longman@redhat.com>,	Mark Rutland <mark.rutland@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,	Vlastimil Babka <vbabka@suse.cz>,
 maged.michael@gmail.com,	Mateusz Guzik <mjguzik@gmail.com>,
	Jonas Oberhauser <jonas.oberhauser@huaweicloud.com>,	rcu@vger.kernel.org,
 linux-mm@kvack.org, lkmm@lists.linux.dev
Subject: Re: [RFC PATCH v4 3/4] hazptr: Implement Hazard Pointers
Message-ID: <aUSbhiMgluudbVEG@tardis-2.local>
References: <20251218014531.3793471-1-mathieu.desnoyers@efficios.com>
 <20251218014531.3793471-4-mathieu.desnoyers@efficios.com>
 <aUO9KRaP0FXpm_l9@tardis-2.local>
 <fcbc99d0-b7c7-45f7-9cf8-f5d3bfad966e@efficios.com>
 <aURihbmjsKi8m7MO@tardis-2.local>
 <42607ed5-f543-41bd-94da-aa0ee7ec71cd@efficios.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <42607ed5-f543-41bd-94da-aa0ee7ec71cd@efficios.com>
X-Rspamd-Queue-Id: D2AA9A0008
X-Stat-Signature: dwewoie656j6ny6ew6eh1b4y1fjxwrcw
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766110344-492941
X-HE-Meta: U2FsdGVkX1/zsF5nhQrki1YBIyFrewkqgKjvOlQdTaW1vScIzfSOsNjijBm3gRNkbL+LznaPAJUDG+dQc89g0ymqB3Ze2EfSfxDRjbF7dtYaqDuvwxg0XTAe8aIARZUuOK2fGVBUctGbQEp6SV6DP8Jyx59xaHkakZm+LTvThUd84lyItP6PRAUEC1Y07lL3WbmgXYBtLhQCf7WvPQOUheY82jDXB3+4+IVjjlIaDz9hz6eRGsj3kEesHvEM5yqqzE5rom/J2zK+66o1gxQGXdVfAUgIhu4Dm5Gp/BdpDlzyhj42E527jHZlLzrclKddC/SziqtsYxBaXkOUuaZk1EQupKuwtTkS57U4+bfxyB0ikowf8dIoAUe6ZIeTHcRxLOQHgFW+ZI3+ja/3ag1MuPUpdfBilM2MutRsSDhQJfVRXfGEIHogkrHmqiAnkc3TN0AoVrlV5YDmp/4GEY3zUVARAKvG+Esv0Ms69V3rQXYOeYYaDdv8+wvFN0ZzfGlmQrP702d7hJ9438eOA5yaEpIQgQv+BFFmwPThBzk7T5GASXLsxGEm3dQp3eLRco42BTaPMYmuxVWC3St8P3EHAEwF+JNBZMho6c3yGpnILLHcFZX5Ss7k0CMJZSEUKBFUneINFsloM+zUgRTV51HV75EhgYNv2Qwv6FrV0Ay29y2tY38JoRmduqqs3XiCMBu1O1RCswuhL35j6N91VNFqCrBY848Cko43Ggc4d3CqmRy6mH0UHu4CVlMz9WWLF3Oj0WcAMG7kA4hunb1NOXse+y/0CA3mQRRh5GByebCYkGv0PIHVrivs5a0h5OGZ9mxa4QZ4uMLYfJb9TSo9AtLXixxmzO/ZQxWShrWNNSqeyACkwdoeQMCJf7aJYD/AjzoAwXHqXT9FhSO06lQlIZ3t+rC5NcN2Kr7AWqb+/aWowff727pTfACngM3sCttnAOvb4WqR7MsuOtTxnY8aE3v
 rRZ/ezDw
 7ppHcLA08+bSFzdCETg1RdCumlQzUdMLsUKzQXsyaZFt722gyvcxDBwDgVtCgqIaJ68g4FkUda8BZNLPzZ0b5Vu2+VDwcRJrgxIoj+vJS0GA3v/7Y9iitRDRRUX2FKliCFFyoWKffGlZjQHFImYn6PLj819pEjF8AkKQ4L3vdWBd9y/9CHQ1ZJzd7K4oGiNN/9sQ6o8c3wBNuiHnTvlgfpZNMqHDp72gCbLsuagpUXAXxdMmgkE9JuKR1nd1jIiBw5bpJNG13GZpQMT5cZB1ZckZZ16Quzo+nzvXigZgjpVfcCoBEHf1F/6SBt3vr6jKriLb94bVYqXg618UCIcU6taQvl8CrdJIFdNLxfICH04KZ7Ef4tKndKQl7uIDTds+KbXoVvVw9Q8ax465PUxU1LFSQ18Kc5kWNHePeQ4M8XWbP+drMNIc/703zirh4fJKlLcWMqvn7yD8zkwRKsfVV70lU3GEDeYDjlwqEAwhYALFhMr6cF/mp2yR/ud/WPa++UtAG7qMTJPTlP/zwBL/RTjVvqblGTekZ7MGpj8JC3obw8kRvTx47IfwgxnO+8Y58r4TPiUw/E4PCOdiC0+MhkpYeNU7+R+1HXWIW+5w+Kny8pHk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 18, 2025 at 06:36:00PM -0500, Mathieu Desnoyers wrote:
> On 2025-12-18 15:22, Boqun Feng wrote:
> [...]
> > > > Could you utilize this[1] to see a
> > > > comparison of the reader-side performance against RCU/SRCU?
> > > 
> > > Good point ! Let's see.
> > > 
> > > On a AMD 2x EPYC 9654 96-Core Processor with 192 cores,
> > > hyperthreading disabled,
> > > CONFIG_PREEMPT=y,
> > > CONFIG_PREEMPT_RCU=y,
> > > CONFIG_PREEMPT_HAZPTR=y.
> > > 
> > > scale_type                 ns
> > > -----------------------
> > > hazptr-smp-mb             13.1   <- this implementation
> > > hazptr-barrier            11.5   <- replace smp_mb() on acquire with barrier(), requires IPIs on synchronize.
> > > hazptr-smp-mb-hlist       12.7   <- replace per-task hp context and per-cpu overflow lists by hlist.
> > > rcu                       17.0
> > > srcu                      20.0
> > > srcu-fast                  1.5
> > > rcu-tasks                  0.0
> > > rcu-trace                  1.7
> > > refcnt                  1148.0
> > > rwlock                  1190.0
> > > rwsem                   4199.3
> > > lock                   41070.6
> > > lock-irq               46176.3
> > > acqrel                     1.1
> > > 
> > > So only srcu-fast, rcu-tasks, rcu-trace and a plain acqrel
> > > appear to beat hazptr read-side performance.
> > > 
> > 
> > Could you also see the reader-side performance impact when the percpu
> > hazard pointer slots are used up? I.e. the worst case.
> 
> I've modified the code to populate "(void *)1UL" in the 7 first slots
> at bootup, here is the result:
> 
> hazptr-smp-mb-7-fail    16.3 ns
> 
> So we go from 13.1 ns to 16.3 ns when all but one slots are used.
> 
> And if we pre-populate the 8 slots for each cpu, and thus force
> fallback to overflow list:
> 
> hazptr-smp-mb-8-fail    67.1 ns
> 

Thank you! So involving locking seems to hurt performance more than
per-CPU/per-task operations. This may suggest that enabling
PREEMPT_HAZPTR by default has an acceptable performance.

> > 
> > > [...]
> > > 
> > > > > +/*
> > > > > + * Perform piecewise iteration on overflow list waiting until "addr" is
> > > > > + * not present. Raw spinlock is released and taken between each list
> > > > > + * item and busy loop iteration. The overflow list generation is checked
> > > > > + * each time the lock is taken to validate that the list has not changed
> > > > > + * before resuming iteration or busy wait. If the generation has
> > > > > + * changed, retry the entire list traversal.
> > > > > + */
> > > > > +static
> > > > > +void hazptr_synchronize_overflow_list(struct overflow_list *overflow_list, void *addr)
> > > > > +{
> > > > > +	struct hazptr_backup_slot *backup_slot;
> > > > > +	uint64_t snapshot_gen;
> > > > > +
> > > > > +	raw_spin_lock(&overflow_list->lock);
> > > > > +retry:
> > > > > +	snapshot_gen = overflow_list->gen;
> > > > > +	list_for_each_entry(backup_slot, &overflow_list->head, node) {
> > > > > +		/* Busy-wait if node is found. */
> > > > > +		while (smp_load_acquire(&backup_slot->slot.addr) == addr) { /* Load B */
> > > > > +			raw_spin_unlock(&overflow_list->lock);
> > > > > +			cpu_relax();
> > > > 
> > > > I think we should prioritize the scan thread solution [2] instead of
> > > > busy waiting hazrd pointer updaters, because when we have multiple
> > > > hazard pointer usages we would want to consolidate the scans from
> > > > updater side.
> > > 
> > > I agree that batching scans with a worker thread is a logical next step.
> > > 
> > > > If so, the whole ->gen can be avoided.
> > > 
> > > How would it allow removing the generation trick without causing long
> > > raw spinlock latencies ?
> > > 
> > 
> > Because we won't need to busy-wait for the readers to go away, we can
> > check whether they are still there in the next scan.
> > 
> > so:
> > 
> > 	list_for_each_entry(backup_slot, &overflow_list->head, node) {
> > 		/* Busy-wait if node is found. */
> > 		if (smp_load_acquire(&backup_slot->slot.addr) == addr) { /* Load B */
> > 			<mark addr as unable to free and move on>
> 
> But then you still iterate on a possibly large list of overflow nodes,
> with a raw spinlock held. That raw spinlock is taken by the scheduler
> on context switch. This can cause very long scheduler latency.
> 

That's fair.

> So breaking up the iteration into pieces is not just to handle
> busy-waiting, but also to make sure we don't increase the
> system latency by holding a raw spinlock (taken with rq lock
> held) for more than the little time needed to iterate to the next
> node.
> 

I agree that it helps reduce the latency, but I feel like with a scan
thread in the picture (and we don't need to busy-wait), we should use
a forward-progress-guaranteed way in the updater side scan, which means
we may need to explore other solutions for the latency (e.g.
fine-grained locking hashlist for the overflow list) than the generation
counter.

Regards,
Boqun

> Thanks,
> 
> Mathieu
> 
> -- 
> Mathieu Desnoyers
> EfficiOS Inc.
> https://www.efficios.com


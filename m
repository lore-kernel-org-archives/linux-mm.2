Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C251FEFB6D
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 17:00:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD6EB6B0005; Fri, 27 Feb 2026 12:00:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A84F66B0088; Fri, 27 Feb 2026 12:00:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94F9F6B0089; Fri, 27 Feb 2026 12:00:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7D2496B0005
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 12:00:36 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1101E5B67F
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 17:00:36 +0000 (UTC)
X-FDA: 84490850472.03.48CF0F7
Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	by imf27.hostedemail.com (Postfix) with ESMTP id 333B540004
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 17:00:34 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=rowland.harvard.edu header.s=google header.b=dK8Ps2gz;
	spf=pass (imf27.hostedemail.com: domain of stern@g.harvard.edu designates 209.85.219.51 as permitted sender) smtp.mailfrom=stern@g.harvard.edu;
	dmarc=pass (policy=none) header.from=rowland.harvard.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772211634;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q632p5k5HIhX1voseqCzyNwQgf7bQCIjs7aoYu62cBE=;
	b=A13FP0lR6LdnZ7kd5J8XaZdu5WzMWAlXrsnE7MUtuj5z3GKjbQnrgtpwzgMP4dqrqOfeCQ
	QYb99hCXmjxGK00zhZcL5NPV2P0F+ohKuJHFw4T9txxP1rACjgNLHoSKyQNQQtYhcTCfJf
	92zOElaYaZBZl8ep4cEseJKs3kVczk0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=rowland.harvard.edu header.s=google header.b=dK8Ps2gz;
	spf=pass (imf27.hostedemail.com: domain of stern@g.harvard.edu designates 209.85.219.51 as permitted sender) smtp.mailfrom=stern@g.harvard.edu;
	dmarc=pass (policy=none) header.from=rowland.harvard.edu
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772211634; a=rsa-sha256;
	cv=none;
	b=QVupPKbwg+Pkqi8z80QVtwHV/zIVnZljmlx/ZgVSD+RpnKndq/O9m6oOsbAdFvz9Txy1mb
	0jVuZG3q8tMrSyHJnCal9qR7oGrpikcWAa2AYpS+bF6ZGtWOFZ8Y94KBpT+EdBmMNc5RvX
	lXrHOULcdfSF7gx85/h9spll0aHZvhw=
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-899a5db525cso21217946d6.3
        for <linux-mm@kvack.org>; Fri, 27 Feb 2026 09:00:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rowland.harvard.edu; s=google; t=1772211633; x=1772816433; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Q632p5k5HIhX1voseqCzyNwQgf7bQCIjs7aoYu62cBE=;
        b=dK8Ps2gzKmfvM8UCHmeCi58bVGAtC91hneGsvarJYIlEzyT70amB0KWlXyLsS+Pduh
         F1FVNkry5WL1fdMgowhUk7EwY3kNKHSaf4yAog+VF9Lb98mI8L/GfHZPap75f0wokVRc
         UKXp5Q+bypSR+tiXSY7ffAhjeALlLH1jVtJgewSeM7g4ypEOe6dCvAg1DDIqQJNo7cUm
         sruR3023Y72FOvwkinCBMPSATD7YFpsJh/nBBgotgxQ8YAhWSK/1t1Ugax9V1vllK0wn
         wURc85AFI+lZSKlJHEz8323bwNzK2MCGiRV3XLz2lamgA0eU2b9e8yzKj9kW2FKzHjjE
         eCgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772211633; x=1772816433;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Q632p5k5HIhX1voseqCzyNwQgf7bQCIjs7aoYu62cBE=;
        b=W/7N7bALaW66VQdbfcDVscBxFZoH7d8OJ8hd0WyAkFeYvNoqNla0m3MBH9fccGTfAt
         S5AyJOJKXzqPF87lTCOhW3M+5TLXEMq55hMZn1cByMUov6/5volvYmiSjLeLfw/mmPDh
         F8+fP0aOuDRZpXxtUlOMvAfYfdQHFNunSs19V2rZLWnO86KDZWVC28rfsJl9+tmxRoE8
         JUg9mT6/Rx4LF4/vyNR7JR/H9TMuPOzUsHSsEgEaEL/jg/lt52iDuA+ckQuk4GKFS1uK
         boXlqKzYHAPR7nsid9xgQBtE5+oDfR+gXvwdkgxaJ9HEis7bxdqS09QaXigHn6biGA/C
         y6WA==
X-Gm-Message-State: AOJu0YwEP6ZK3aI+EJ2jkLMakvA1y0pcIS9WWQjXsDQelAJ3e8onTdkf
	RZLiKHKgt042M7+Hzq5H5/uiU5zih3VhasGs5HpnKrnm6E6RRXs4Za6wONLc+BX44w==
X-Gm-Gg: ATEYQzw87rxrnQCdGkHQ1P/C4ZsOeTHwe8IvnEPX/mqBZTXlC6Go+smiTmOaAvoC9Ll
	X+aYE9ZA0J3NC9J8eOfUr4PH8Zfj8iqa4D9fB8mxq1QWQ+X+cEVoxtbo70vEbx5bJ8kni71T3U7
	GI2L8IGm2rg6ZGAu6I/8twqvO44XFLh+nWsZ74iTIptrIOOda39aAmcffbpYmMJFuMGwu6ervii
	a3Mq8p0Y0UMabYyvyHqZOgjDQ8bEZCLD6iqYUeH0kHaQxGU7lEBHJjljn2Ph/illdOUijLmZefh
	w9zFGggm/ZUS9Pk6NqLX5qIq88kTTCRK2QDqhnzG/7zq1BNmyIaLsOakgS1XWS/Ef+nTGtW5VXy
	/cc8i7h1k8hAMB75XQ07vEz19xRQESdIQyiqA1nfXK/2M2x1fPSuS6Y002efjy+0/sXBw8+BNzp
	/rC7uxr2G36DyixeqhMg7pXj2e
X-Received: by 2002:a05:622a:204:b0:507:358a:2b11 with SMTP id d75a77b69052e-507529dc2e0mr45494721cf.67.1772211632498;
        Fri, 27 Feb 2026 09:00:32 -0800 (PST)
Received: from rowland.harvard.edu ([2601:19b:d01:d210::687c])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-507451cda0asm53695991cf.24.2026.02.27.09.00.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Feb 2026 09:00:31 -0800 (PST)
Date: Fri, 27 Feb 2026 12:00:27 -0500
From: Alan Stern <stern@rowland.harvard.edu>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: linux-mm@kvack.org, Dmitry Vyukov <dvyukov@google.com>,
	lkmm@lists.linux.dev, linux-arch@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Daniel Lustig <dlustig@nvidia.com>,
	Akira Yokosawa <akiyks@gmail.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Luc Maranget <luc.maranget@inria.fr>,
	Jade Alglave <j.alglave@ucl.ac.uk>,
	David Howells <dhowells@redhat.com>,
	Nicholas Piggin <npiggin@gmail.com>, Boqun Feng <boqun@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Will Deacon <will@kernel.org>,
	Andrea Parri <parri.andrea@gmail.com>,
	Pedro Falcato <pfalcato@suse.de>, Vlastimil Babka <vbabka@suse.cz>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Hao Li <hao.li@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
	Mateusz Guzik <mjguzik@gmail.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Marco Elver <elver@google.com>
Subject: Re: [BUG] Memory ordering between kmalloc() and kfree()? it's
 confusing!
Message-ID: <556c5caf-c453-473e-ba92-f49ac34053a0@rowland.harvard.edu>
References: <aZ_lJAqxh_hNGr_v@hyeyoo>
 <9dcd02b9-42da-455d-aa08-165e6ff0b921@rowland.harvard.edu>
 <aaByMLSAIJM8HdbO@hyeyoo>
 <d8308828-ed28-4650-8c8f-22a7e5cfd1a0@rowland.harvard.edu>
 <aaB-1e1LoxkcYl2f@hyeyoo>
 <9240040d-598e-48bd-b802-bf91cce92d0c@rowland.harvard.edu>
 <aaGP1Se8vkBhn9uj@hyeyoo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aaGP1Se8vkBhn9uj@hyeyoo>
X-Rspamd-Queue-Id: 333B540004
X-Rspamd-Server: rspam07
X-Stat-Signature: 11pzi3gaahh7mzdo76bhjnr5tcq9e4i7
X-Rspam-User: 
X-HE-Tag: 1772211634-410763
X-HE-Meta: U2FsdGVkX1/xiX1HW0w+25RJ9fbnOFnTndZXFRTTHYhweRO4mkQasG+CxtQpEApJSvVS3pI+8JzofKeXtvsSNepBAa+UYm9GCZcF1IhkHjz6Ht+UgHtGxY2NJQTMBSzXGHdIWTIykpbQxzv7zW9qCMQ8HXgI8JCrseoyAyGh2NIT1wd8Hf7nQ1NAVDiKJlryxnac3vfK9JpZ6mA1gEAcH8SqiBunqkqLJuLSBBYOasSheS1lLgb8xjNokyC/H/n7sI/Sox73bKDAz+cR0bdsZCo1M9L7tkGM+7Z8dLjr6wdWe5t/TFIwG+6rSYfCj4pig5rVuIk6bAqnAsHNwWGvox6WtPGpylJpQPYJlXn5A+ZDEDipgEijs65TegiBFQ2elFq2sWb7AxhYZe6TO+dxOqxrLxMnejDg0TgnUUW7GC3FDcC45cPOvna+kN4uNUEX2BhTj7C7Tl190DiUFhQd49QUPPAMFBjog8cBnJVwyUf+3ISb9mR4gNZo3JnTzqFLLqGvR6jn/vBJC6BC6oC/VEXG4RJmKXr8xvZ1ERXgFkBYFhdHfUUe+PVqk94EjyJ4PEZibrOZ6R4iSjXFmuvndj9O5c4/TVn6/fHm0/osmjFLJs/gmN99DUOrbEfaN1QSBW9IHow/ZyJISWuBuDyRz8L6O9O6cIJSv2xYN70JrS3Pqe6Nyl+Es+/dUTMnS6dnNZnWFiz9Jhze7cOK/Z9fDGOUvdV3Y0w2Df2oFsVhDbS4JfBBXDRquzhe3mgAMXMOpNQpnIrSrFIcCPxCyzrA4yDqqlqqTQdYUPPyeZ5LPUpeISS2DQN5Ov0INQ43GFnFeQkgBxIqQe0tkOpLdwLtWtFqK1W2xw+sMxSTqdB9JEOZ02IlVCkDagxN6ml3A0hB6Hyj62XlbrUufMJBh5ktuR4CNFB1hxWVqhDH1rM5qEkRqKa/Hej0zLgcsW7Rt8L08hS+1j8TkIIJf/WTXap
 flnL8KNa
 fcG068CEL6ERK7ZBkd+T+dZ2aUF18f6vlHTX4jsUFQU9Km4i14ExakoI5R69pfOZ1Oi1GKExdNNJAJcrNFipeDxg1FEuYcw5B3hPjJUTzZP0dPgeCHTwpNcGC/Qlx3Ml+FEO6oVPINK9xG3zzI9i6M7ITc/SiP7cIcRbbwv9gJQ1OsYHd8WayQhNfwfd4XayujwMo7qc8YcHGDppDtdVcPEcMIBh5Ix7T1giqrGuTO4YB1Bv4XkYI2CgFntK+kb0mAKgbta5u0+oItQ46kkkVNOnJsfqcTrF0NvVcDQLZjqKID4ITuD3IupfL+DIf4p+HGkr7PJvWpoVjxo2YkKltN4KSlpaqZQsdtjSIfZarXSodPam9uus6aOKlq46TfBTssKXPTWdzd4VZjQZ9mTuJ2j3EsTMTOFbqRs/zMcJ+CrROFcRiDZ6daQWLEPZuntfsV4Ukh9WmqCLL0xm08afQbe0wtz6YrJ/yCHcyGTU2Efrkudtw6A3jph04Ey4/vkviAzANcK8xq3uXMcEgUx0fn39Jw2twKEfm8fXzfXI2kr8rgwOVvw4LXWL8VH2NvSICAOyaFZ1roU/vej6ax6fAU378wQ6tWKwQ2xQvBn4lW3ealAvhnm2fRMVff44efFbiPGdL0Bax1ala1Ms0DSZrWM3N27v5Dy6IYpohBBVl8u0UhZSnF1nxV3nn8euApBEBCWXt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 27, 2026 at 09:36:37PM +0900, Harry Yoo wrote:
> > Which is: The same mechanism that the slab allocator uses to ensure that 
> > CPU X and CPU Y won't step on each other's toes if they both run 
> > kmalloc/kfree at the same time should also be able to guarantee that the 
> > metadata changes made by CPU X will be visible to CPU Y if Y manipulates 
> > a slab that X just finished with.
> 
> Within the slab allocator, I believe there are sufficient mechanisms
> (either spinlock or cmpxchg) to prevent CPUs from interfereing
> with each other.
> 
> My earlier statement "Because the slab allocator itself doesn't
> guarantee such barriers are invoked within the allocator, ..." may have
> caused some confusion. To be clarify, the slab allocator of course uses
> proper locks and atomic operations to avoid CPUs interfereing with each
> other, and yes, those mechanisms should guarantee that the metadata changes
> made by CPU X will be visible to CPU Y e.g) when the object is transferred
> from CPU X to Y within the slab allocator.
> 
> What I meant by the statement was that the slab allocator doesn't provide
> enough barriers to ensure correctness when a user performs a drive-by
> free on a different CPU w/o proper barriers.
> 
> Hopefully I'm not missing your point this time :)

You got it.  :-)

But since I don't know anything about the details of how the slab 
allocator works, can you explain in more detail what the locks and 
atomic operations are and how they prevent CPUs from interfering when an 
object is transferred from one CPU to another within the slab allocator?

In particular, which part of the mechanism fails (or doesn't get used) 
when the object is transferred by the user with no memory barriers?  I'm 
trying to learn exactly how these two cases differ, because at first 
glance I can't imagine how you could accomplish the first without also 
accomplishing the second.  It seems that transferring an object from one 
CPU to another within the slab allocator should be very much like 
transferring it from the slab allocator back to the kmalloc caller.

Alan Stern


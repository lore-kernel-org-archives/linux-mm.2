Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB786C982CC
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 07:23:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B82736B00A9; Sat, 19 Sep 2026 03:23:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B33336B00AA; Sat, 19 Sep 2026 03:23:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A258C6B00AB; Sat, 19 Sep 2026 03:23:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7CEB56B00A9
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 03:23:43 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DDCACA01AE
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 07:23:42 +0000 (UTC)
X-FDA: 85229671884.29.038EAA5
Received: from mail-ej2-f29.google.com (mail-ej2-f29.google.com [74.125.228.157])
	by imf17.hostedemail.com (Postfix) with ESMTP id 1158B40003
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 07:23:39 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TZuqxdWj;
	spf=pass (imf17.hostedemail.com: domain of urezki@gmail.com designates 74.125.228.157 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789802620;
	b=ETUKGzWtr1yV2sFKt2ZzKtKRh1m1IpBHb6w0ijQEp2XP0B0lHjudLRHX36Lz8YoH1q4MyJ
	CujXdYypCH7Yyrxwj7gBRT23nUxqe0RRp/LQTAumFQIAjoqB8NABwcFY2SGmeyAjJRJIt+
	Qe2cGY23xtFt3iAiktWU/I2DyPY8O9k=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TZuqxdWj;
	spf=pass (imf17.hostedemail.com: domain of urezki@gmail.com designates 74.125.228.157 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789802620;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RQSHCzZ6TcJ3oHS0FafhQVuKcCiSaxKKxZ3P8CRrLwE=;
	b=8idcfy5HJQNipGii3qoilJlj6BRZfE5xWCZwuUk0MDx/JZE7oq27tvuPwaQPkrRNeJFqGt
	1z2TVYz3R/OBKiTo6HF43EX0gwqbDYNof/GvF/a1zSc8bcCY1X6sKdYNu9QmSPhY9w+u9y
	WsQfiPafniAaZmcHV1loGkDIx6G7Vzk=
Received: by mail-ej2-f29.google.com with SMTP id a640c23a62f3a-c294496989aso199804066b.3
        for <linux-mm@kvack.org>; Sat, 19 Sep 2026 00:23:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789802618; x=1790407418; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=RQSHCzZ6TcJ3oHS0FafhQVuKcCiSaxKKxZ3P8CRrLwE=;
        b=TZuqxdWjK1RExTp/hgVEqf60kwCrUp1BgqdrsC/QzO6hF3lmllYVp+hEOo4ATXZfiU
         ipTXhhZHWsagpgErlck1+maGJ0MgxhHvpTOk9n47N3l1Pp+sxcIw7PIsbTZ684bOjmnG
         HyqWdQF4iox8HQ/t0FaNeuJBt6D9n5dtbeKjhBrvaPHrg2MEJzOJ4xYtt4WGP2L9iXS5
         ihT9Vnjho88RqXSHhaqu4eA/IZmiAEsm/DNdwhWTnjTk7TQEdUFxqJO+DSVi+rFq1ysX
         a7iWtbrYL0cCl+5qZPFyWkCc7PgFo+blYA0VNIX4OdkqI1iLMvivF9GVkC9BXK7m3aOx
         BGwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789802618; x=1790407418;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RQSHCzZ6TcJ3oHS0FafhQVuKcCiSaxKKxZ3P8CRrLwE=;
        b=UyvaQ/OYTa7asSyoXprCk56nvIf/KSntUT1Lo+0EC7CTz4+MOUMgRrF9DccAdN4LZh
         5e3A2ji62Tv+4h6Vn55RaWwimdU3zX63firT0N6yp6g1R25WsG2BFMNtVSGLPpPmMwKh
         78fJkyK/tyU+X9CXElzIBuQCTBF9ClU6K+50guBucM+6K17VP/dhoEOZ1HQBglDpiDm9
         cUHuzUCVA+Q8DXds9crjVksLhcuzAzItppPsO4RTjCmwvBuJ4fXhTGgGpQiaH3o/hDiL
         +Hb7qt6mQNbigPCx6kIEBCegYBN8/ZepePjBP0N0u7G9/R24uau1XShqblzna/00A+j0
         qZQQ==
X-Forwarded-Encrypted: i=1; AKwUvBwzS36qx6MnIWlj9WlFWm7Hpi7k4xJ9Qcn7twJy/L6VwU5Dq0nYfUEAMd9YtmHGvwRY2/zCiVXGlg==@kvack.org
X-Gm-Message-State: AFuF++lbTPjg3R7Dzq4Vz+qXH8RqodRyx6Gf+4S/dgnDoaP0tvlcYg0m
	X1gHeFAafPAL30Z+1w3dvfN2jKhGYX0i/mVSziC0E70P8HfAU3bu40Dw
X-Gm-Gg: AYBFou200oGaH4I8/yH8DbRmbdU+U48xV5e+0Ou1IIS3loVMv9onro0JaBYbN7NiITe
	Rtnyarqz9AsHgbtGqzVJer3CqEYIomU9CVGbw+MAk8+un9Yv+flfUJ1s0wPHEUy7qNaRlO29dIa
	Y0VORNDl/P6xZ78jRCMf9yiK/35C2XhKGEJRlHIn34SVYvPyX+a6vezKlUg9FRhw1xM7vmvbPZ8
	JwiH2zR3pQDcxMruVsrpiOVUJowgn1e71eQpJ1XtJ73meIPN6QagWAnxUOcH5gpF6/xFDq5Orut
	Be6+EPsAP56xXm7C9X6y/LdMtFLemQReN1/qGlVfPY3S2BW947AJ4ISAezVJalP5xq51Ru5D7gg
	/eKxmvOKPkNiexCr/qmQwCLmZEWo9M4laZRTtFwjyW1qfqi+x9ppOJT8CYD6kO9hc2Iypml6sPc
	EVPsTd1XhJllng7dl+TroFlml8/1VsNZBp/UI=
X-Received: by 2002:a17:907:1ca4:b0:c28:599b:7782 with SMTP id a640c23a62f3a-c2a15b11ac5mr517756066b.21.1789802618337;
        Sat, 19 Sep 2026 00:23:38 -0700 (PDT)
Received: from pc636 ([2001:9b1:d5a0:a500::800])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2a359037aasm62063266b.63.2026.09.19.00.23.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Sep 2026 00:23:37 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Sat, 19 Sep 2026 09:23:36 +0200
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>
Subject: Re: [PATCH] mm/vmalloc: Use %p for pointer formatting
Message-ID: <aq44eOsUuWb6fD43@pc636>
References: <20260918105013.UpdykT6j@linutronix.de>
 <20260919003934.86889-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260919003934.86889-1-sj@kernel.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1158B40003
X-Rspam-User: 
X-Stat-Signature: xi1rszh3iyopkgskj7rd8y89wj8hcmy3
X-HE-Tag: 1789802619-369269
X-HE-Meta: U2FsdGVkX196dDVDLmefxnvjhokRNQKGh7o450GFkSSmo9cTWkvmac8SLrRga0vRptuYBwHgyU82dY65UGNzq3UJUdpM9qWiEDGMozfqbvf9uriddueJITfdSyQJI/Z2rvp2ttW6pmJyuJaZkv2nUDHGq+1W6sHd/vWr5V7ny6nwXibGUOZ4Gq4z7p9yEntT1fCJtDRzFugm1EzvFcjbtd43Y14i9BOq/lHrr9pEJfo1v4fVBbftaq2bvCaNy8rCN8W7TrgrX1PZo6o7ydqHLiZii2+yC6NgBDO1I/bSHXkZF5WfSWUCbjiQAuEqqB9jZH1aVZ/0BNr/78rSD+rffrbhz21ZGxMSH4Wdj/cTIR1UcaUAPOAFvwCcMPvqJcK6c8d1cwfVI9wmRoFnHcpO+OW1uZFeR+Yh8haVELAdcN4b7a6LQSrnkx9vaaDwc5XjJTbzn9y7+AV03J+TBO8ivMJr5q5pAaFCiYjgBkt6PxKiC9LdriZrEikQnj6OZJyOxFXI6HYGGyKGGtMW9QP8QxzarbqCt6WlqtY1V5F6BVjJxqje1JUlMuYx08bbe6lSmk80ZZYVTjlluLX4lHRPlDLERz9OTF/NRPao/BSDwM4LoYV5n6RjbNLcutChpBavJ2WzU7x0wA1VJRNUq3lzsOYAEAvQlP+cg3vKhIPpPq0oKwO75J6X/ZsIJ7B5rclFxcUE2RgTWpIfgzN+r4bzsUZWCx+RZOWETEUAf1pt+tQgtQLlOV6fxluAZ7UVQnXnp4/k9EVQJaaFxE1rALPPPYwSRsb55+SiD4m7xdQIDdtv5crn7v09GPgK0g5QPmxUmKAmcF+gxVZJVd1LvaSapBOINwO5bz6q8TYm59Ehv3gqvcyN43JRPuS/Uttc+0K25ufl5AavB2O1jprPEnoLMTymQacHBm06yUnkMl/fmO++PA1FFmXzp3pmVdQt5uP1YQiEB3WrTB46H6rZnWd
 YZ8on7dU
 gUB8ZzgDdPYrQj9zfJVx/lIZMYdwiaoUoU/uhNvUrnjbS0WPJ51s37DzFpAiY9dPnkOYqhUq1zvEhYcS/DajFJYtOpu02QcyDguvTyE0E8vZbQtl5MJ+VuFMZMhzDngyyGvys8AltIEl/yFCmdIcrd1G8dGmYJMExgOIzVYiL7+0jeKwocyTRxnm/5OCKmHEatBNUaQsUAAEv0UhNPEN+f7d1OEPOOh3qE6BnDPgREnYsO+to4sQktWNPxNHWWx0gubDuEK65rO5sxufTTIHhRtCpH+zRTNjvfoebXm1SgXad+4rFdFd/KROB/BlF/lxQN1z6T9Qoc2VmCnXI9VW6hQrgBK4YjvjPrC2RiKuAOO+riDoCAjON5MBGDV0fbGw9ZaOGRWenXF4KZR0o6q3skc0LYKonAsI/0PPEEC5TW5/pORQBnuIn2niyObmRt4XWOSXuDJlKLeiODE6ysONM7IaDe0Z7SLK+6fAsMjluWnWD/Ae7+hPBpmSN2u5huafsXVKk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 18, 2026 at 05:39:33PM -0700, SJ Park wrote:
> On Fri, 18 Sep 2026 12:50:13 +0200 Sebastian Andrzej Siewior <bigeasy@linutronix.de> wrote:
> 
> > Commit 45ec16908e84e ("mm: use %pK for /proc/vmallocinfo") introduced
> > the %pK in order not to leak kernel pointers.
> > Since commit ad67b74d2469d ("printk: hash addresses printed with
> > %p") pointers are hashed by default and the behaviour can be controller
> 
> s/controller/controlled/ ?
> 
> > by `hash_pointers' boot argument.
> > The policy on %p is to not introduce new ones.
> > Removing %pK makes it possible to remove its handling from the library.
> > 
> > Looking at the output, having the pointer in the output makes it
> > possible to distinguish the individual entries.
> > 
> > Use %p instead %pK.
> 
> Makes sense to me.
> 
> > 
> > Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> 
> Reviewed-by: SJ Park <sj@kernel.org>
> 
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>

--
Uladzislau Rezki


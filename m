Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D349CCD5BB1
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 18:34:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F6526B009B; Tue, 26 May 2026 14:34:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A6AC6B009F; Tue, 26 May 2026 14:34:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BC886B00A0; Tue, 26 May 2026 14:34:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 77D816B009B
	for <linux-mm@kvack.org>; Tue, 26 May 2026 14:34:13 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1DFAD8BA99
	for <linux-mm@kvack.org>; Tue, 26 May 2026 18:34:13 +0000 (UTC)
X-FDA: 84810420786.25.B028F6F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 32E9F4000E
	for <linux-mm@kvack.org>; Tue, 26 May 2026 18:34:10 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=058LaBr4;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779820451;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ten4yU23Ac++inidkaUZfcmTNHhvUCtXpX8S8RV5zAs=;
	b=Rd6mMdWttrqMKnwqwv6VqeJ6vSFtm8ChUWAg5UzuN28UXaiGdzgTvIoOcVRFECee2wMC3y
	9FZpQarbh6dvyS2IHgcF6mf1HuRTMTLYrJSpdcWEtW9oTD1ZaJ3iAzZiriv3EmC9x67bQm
	yp1ZYDlqxIBPPnO8LPduHauA+lZH+/M=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=058LaBr4;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779820451; a=rsa-sha256;
	cv=none;
	b=BBy006ro4Za/VqukpPfM6cF/Ohg2L/npOKtu6IOhrflfYw2eFJHjGrKrkB+abLvBgdmhNv
	Qaj111Ods5D9zow0ZZ3uE+9yXJQ2LzW5ki+3U0r8eQwgWZmRX+S8MlhbCZ4wme0NI0ZOAH
	eFHCohgS2+nGGm9ERNyDe9jGZ81Ydxw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3769860121;
	Tue, 26 May 2026 18:34:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81DBC1F000E9;
	Tue, 26 May 2026 18:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779820449;
	bh=ten4yU23Ac++inidkaUZfcmTNHhvUCtXpX8S8RV5zAs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=058LaBr40gFFVrI+tEcI1F73LCQl9qspfIq+A33YQ+Ax8Nob0h18JqK9snSIkiNOo
	 iD5JKhwtBvwLzWcrrSL30ERHyUqTx7Y7hdPoHkV1HpnKkJVArhZLZq6YgTz95uWuzK
	 q62/9tyZXY0zhx1K7XbMAOKVo89e70I+5L8oBE9Q=
Date: Tue, 26 May 2026 11:34:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Chris Gellermann <christian.gellermann@codasip.com>
Cc: brauner@kernel.org, shuah@kernel.org, david@kernel.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] selftest: Fix UB of getline due to missing var init
Message-Id: <20260526113409.ea65314eb1da831de7c90ca6@linux-foundation.org>
In-Reply-To: <20260526113848.530105-1-christian.gellermann@codasip.com>
References: <20260526113848.530105-1-christian.gellermann@codasip.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 32E9F4000E
X-Stat-Signature: 1yge53zzee97fb6kbbwwmc9h8h1k3tsx
X-Rspam-User: 
X-HE-Tag: 1779820450-781958
X-HE-Meta: U2FsdGVkX18Fy3agKgJykrc46Ww+7BOvnXo5attsCjUm6HbWCKnwFMQLoSsELnmA78KF4w7cqrmEDuVRLyHU9bSgQDNTSr4UIS2W/EL6ymJrWnU8mOcAHOVQrIbZif+czAs8W/7W3hTd3I832Nu0clVBM++zOzM9U9MaarVxgiW3oG4bmR+502Deo2xqw2agRN5z4qDYVZFyI03D+74XFYx5kd5O8LMKk5Xvo1IkHkoRvEVITCPlC3U8KPBDQrXxQ50Xb4y3I/3uphVnfSSd0jjVV7EaCvqrV5DW03b5Ao8OwFWV3H0E7qjgC9AaEO91zdGN2v3zluPMxBOq1Xf5zlxGRg0Z6Y2OqptCiYRwP2BQtct+MJst3PGULqdg1zaFzkZpIAdUiCnLfpdghtI1i3waSlQa/gswuqpbiymS0rQ7fRWoyfGpbWpMd2pXKlqA7cIX+iTcMQnBgL7hcBTJKR4a5+RQEA6aDLJLEBo6pQW/i2RGBtu5PKoeiP1EgNlMzE58/WQdf4sIVz5leNN9O/aBp66TpZ0AYkluFnP0W4TYtVyscuoMvvexaT82Jo4wnZv9tcBy6AmSXyeQh3UMHkSJqpjqbOxAGYWgRkhiolSFBby0KTjsRlpltb43lwRtVbVvQFf6TxpcMCWEQwONbOZ+Wko2LgaiP1O4A/BNAoUCAaKpWhhbqNY15wSD0Pem/xg1vaxhU/2A5A+Zeehtp1wOi6xW391myJ4U+W5QLCZWNMfPFmfIJHkyVkEvWDghT6diNhLHii7Xj7J1val71aOSFymZ+GmkICWgHUtsvvG/QHG0m1hDbdXnG835Xglg43yBLDsAs/so5ZDidJ6G1k+9ZbsmuvkBaltKNeNFmSZiKMfPB1g7fr1BTUeXsPuZ4GR3CAaqC70M9BhrDps4o/zMw1RWuz2e5uhbqMxJDsQB2GisWansvTcnhf4Wc0/PyRFGOzcKfX+BEMIyZK0
 9Fxr1mVf
 f4tIoR8Z8TMgntu2ZMG0xlusYUPvHuC+mcYvRbBZUY50aHLEBf0Pp2Bt2UAmw1xiHpLZxAX2hK4spkU043lZuqLDF8SPHmpA7WOTaShEk8wqDS/jJBtxUwVkjNsMK31hbR+JvLbns26L61wOrSs5njbEcD28PXKxTygSxQ7zPBgUqxx3inQT3JY7NR24VQz70XNQ3DifUE554CyxrHAx5Gl7XyEVhdcQCU9fI5TQwN5UbT3oxRAo1jSGtahIBqeutgpcZTW/hi7RffDNyGROy3AQ80fy+PwKMthUJ5SOm9iEA0axdNmgFhffhKI3O+yN6gVhbMk4qFj3vhxhdE6X4laVOHVECt0gbSJkXZb3JNS4eSGE4dkMjbiKP49seJ7Q3Iu17LbzMtrTTsp1uk3bX1exWFjhfaI22LYkt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 26 May 2026 13:38:48 +0200 Chris Gellermann <christian.gellermann@codasip.com> wrote:

> Subject: [PATCH] selftest: Fix UB of getline due to missing var init

hm, what's "UB".  Please expand the acronym.

> Clone3_set_tid uses getline(&line, &len, f) in a loop to read the
> child's process status. The code expects that getline allocates the
> buffer for the line on the first loop iteration. For this, glibc[1]
> requires char *line to be set to NULL:
> 
> > ssize_t getline(char **restrict lineptr, ...)
> > If *lineptr is set to NULL before the call, then getline() will
> > allocate a buffer for storing the line.
> 
> However, char *line is only declared, leading to an undefined
> initialization value. Fix this by properly initializing it to NULL.

Does the test crash?  If not, how come?  Luck?

> Same issue fixed in mlock-random-test.
> 
> [1] https://man7.org/linux/man-pages/man3/getline.3.html

The two affected files are testing significantly different parts of the
kernel.

> Fixes: 41585bbeeef9 ("selftests: add tests for clone3() with *set_tid")
> Fixes: 26b4224d9961 ("selftests: expanding more mlock selftest")

And these were separated by three years.

So can you please split this into a two-patch series?  And I suggest
you add "Cc: <stable@vger.kernel.org>" to each one.  Please retain David's
ack on both.

Thanks.


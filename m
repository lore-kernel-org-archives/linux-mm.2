Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F760CD0435
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 03:40:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB84A6B0093; Mon,  5 Jan 2026 22:40:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D62496B0095; Mon,  5 Jan 2026 22:40:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8EFB6B0096; Mon,  5 Jan 2026 22:40:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B68B26B0093
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 22:40:45 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6BDF7C19D0
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 03:40:45 +0000 (UTC)
X-FDA: 84300137250.25.73F11D2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id F184D180005
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 03:40:43 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=t8Z6HaPR;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767670844; a=rsa-sha256;
	cv=none;
	b=QaRUNgiuXf3wvtfa3S0AwRMvMJ6ybU6bW/dXzq9Hd8L6bFXN4Wrnd+oNnBFTDyxGie20GA
	3XCatadqTrg7/XFDuhpZ0/dUeJnSGS6wIde8TzdIC6Ey11dJc6723Y5w5Cj+jYL472tn0y
	guyMCmh1Km80NWt3KUahi0Htf36j51k=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=t8Z6HaPR;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767670844;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xxvHc/m3EecEzQoN3NYbZzUYmn/ksO8JWDcFC1vRio0=;
	b=rVfvOFbFptvN3sMRgK0UM+r1JXcrzJuGtAoerSARVTU40tnuEWmpzzAdcx+xlPj1OXIS8R
	/5HDjzco79X+WpXt2wzL5L8X1ufcKh4IT9MhUY5vX8YVxiWrrFq6lqe6KFN1ChLbS6UBvp
	0fU1l5rdrkEFubktolQhEgore3ix5DU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 07FE16011E;
	Tue,  6 Jan 2026 03:40:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66F5AC116D0;
	Tue,  6 Jan 2026 03:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767670842;
	bh=h6/TF6yOImEMkPVariXIbBoNskfvDYp016gqU0bPLko=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=t8Z6HaPR0xlnWINY74qevICb/aJ/z0dc5MJ/dyQybfuqxP2HXaarz+T0AJxvcqoF8
	 7geMtSX1iGUbTzWtK+652KJ/Xdb42jz2j3JSdePmLU4iJtIVnCSmGe92WsLKBtqT3E
	 hxkWeEhvmywcA/UEWgHC1p6TAGPr9ZwmrOciDrtg=
Date: Mon, 5 Jan 2026 19:40:41 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: Boudewijn van der Heide <boudewijn@delta-utec.com>,
 Liam.Howlett@oracle.com, aliceryhl@google.com, andrewjballance@gmail.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 maple-tree@lists.infradead.org
Subject: Re: [PATCH] maple_tree: Add dead node check in mas_dup_alloc()
Message-Id: <20260105194041.0f3357f493145baba2525cda@linux-foundation.org>
In-Reply-To: <aVx4PjdhG31LfjuA@casper.infradead.org>
References: <20260103103247.9140cb2556280927b09f59d3@linux-foundation.org>
	<20260103200633.246006-1-boudewijn@delta-utec.com>
	<20260105173350.d8ad7d630be1f0a581dfd565@linux-foundation.org>
	<aVx4PjdhG31LfjuA@casper.infradead.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: F184D180005
X-Stat-Signature: ki6xngtjednb3b61b54ibbck9auti8x4
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1767670843-712798
X-HE-Meta: U2FsdGVkX1+rSdiA/vsYr+THpqaNEW4nxgl0ae9ojqglzoGKVIuGCSPWDqVXpCblfHrQW4qHs65g8JJssdmqWc0mqh/cN/btBrAK86AKFczakvWl2sVDD0U0Hu7GQ9C2Yzju5E+az1wntfeqW3ko0fnIDLX2yXx0N6VEisK0A9RC2CXh6gLbdLD/eHKiB8HfXqCLQz3MnN5Yif0IOYCvsOmbxU21GOgoHUpYVOnT8psQ5eZHFXgNevSNS2cviKtyL4lpypfpsHTFHfJzDI+dJtpkBJH838SnLa4Gp2lW4R4SEJ+td/T9LQ9WIUlViiwKC97PtQr35F64z2MmEMAEEmBRE4vbDZ3+dPe2mmJqcJ/tPP9CJdx8ziOE+o55+QJbIXfo/Gu4/Vl7qojpvLIp6/iNiaPmw9tHpr9MrEf6Al3D01BrmhBGsirzoJ6ETf/2ZE/VvcppQog0yRScaZFtBnG54MiQQUsLuHnddHSfIcQHaeLVJUVvZ0EIMw28yJ0ZN+CKDXT8ACd0P06lhxNY65O7xWXV42yaKFf6y/OC1whkombJIMz/Rc+2LrZQc+WxVHmzcywQSGoCGtBlNDbdXG3VxCqZ1miXYcwPCQbCW3eZXyqrdvPRAf5OS/TfZo240qqizuFbK47PU94W/hBAoNkAmUWb1jRHWpgOyoOsrR5wQhnEBReXOtB/Z/kYHff8vvs+cN/7oL/sArQxWTw3VT0hrEj0s/yYpGuu+6p0tMZQlHvjQoSATV69QbTZinYRXL/KlzOsBkuqEJx29cUFhI3XPONuhpUNlIMrg90jj1J2vYa02S9D3bBAEOzwT6uA8Z1Biip416AC/XlVe2Se/GnrCVKZbV+FH3aN5km426uJQu7GjSSQ6Kju3UoIlbCpPIygfzaYSTtNrmDLshfRJ9bFrfkNztpX7XQQlQrhhJ7yKNYVi8AyrfV9mm1fvRt/+hsvNAfMCAssxHs8ZHF
 h6g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 6 Jan 2026 02:49:34 +0000 Matthew Wilcox <willy@infradead.org> wrote:

> On Mon, Jan 05, 2026 at 05:33:50PM -0800, Andrew Morton wrote:
> > Great, thanks, I added all that to the changelog and queued this in
> > mm.git as a hotfix, for runtime testing and pending reviewer input.
> 
> Surely this should just be a lockdep assertion that the appropriate
> locks are held?

yup ;)


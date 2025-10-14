Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E42D5CCD184
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 21:30:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3671B8E0150; Tue, 14 Oct 2025 17:30:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33F1F8E0090; Tue, 14 Oct 2025 17:30:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27C088E0150; Tue, 14 Oct 2025 17:30:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 170D18E0090
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 17:30:04 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CF4F44799D
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 21:30:03 +0000 (UTC)
X-FDA: 83998012686.06.C41463C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 2F46DA0005
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 21:30:02 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=zn8vuI9M;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760477402; a=rsa-sha256;
	cv=none;
	b=jEP2nHaTHYZ6TjyEcjP4gyuVYTS8DitQbXbI9nRb57SvV+9KtI1270/KFjguH85QYLk6Aj
	28u9xItzsYZNIFbCH3bckF6nFUsush831J/YU7q4e/3TIMviwbXNaxmAPBjhcr1l1S8Jtx
	fctxTqB5tBgs6iSx/uKPe94oSdK7x2I=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=zn8vuI9M;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760477402;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SM90cOepkHLYYsXpwLzTnH2S7KUCIITRSWQiuHeCmVE=;
	b=i5wukhHpCaDkZN+Vr+8ephAL16nnMqLZMrXM/+RjQxwWF0fJ5+Z17Ms/DE75aEAoRBaOGp
	LIEI7+efSr5Sn+DTbypXgo97lbRp/mTKYtyqwlLwtO0FbOVxty2cxlvXIQfncZ/KC/pNL2
	ItNpnxERCIszbv3At+6eZvTuu2Fl078=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 308A762411;
	Tue, 14 Oct 2025 21:30:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EBDEC4CEE7;
	Tue, 14 Oct 2025 21:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760477400;
	bh=sz0RIab+uJDmAtx+yofP3RZAaWLPnwR8PIrrUTZ0djo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=zn8vuI9MGoprYrCJqaLNdOcaMkWNA39uHSdnWX7pIlJsyEOgxQ9Jbu/CMR/HdS8QJ
	 v6T2xsObYK/nuDBNmbUCj6PzyKt5Oye0QVOqWaU+eEe7jPALPSF0VeeEzVsPFhD8Gm
	 JLyEF4e5x0eoYTFiLL69Ldcx8dpcDCZf+xFZeKSo=
Date: Tue, 14 Oct 2025 14:29:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Itamar-Dalal <dalalitamar@gmail.com>
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, david@redhat.com, lorenzo.stoakes@oracle.com,
 riel@surriel.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 harry.yoo@oracle.com, jannh@google.com, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, shuah@kernel.org
Subject: Re: [PATCH] Add a new test 'migrate.cow_after_fork' that verifies
 correct RMAP handling of Copy-On-Write pages after fork(). Before a write,
 parent and child share the same PFN; after a write, the =?UTF-8?B?Y2hp?=
 =?UTF-8?B?bGTigJlz?= PFN differs, confirming proper COW duplication.
Message-Id: <20251014142957.4253f2fc62e9e49bfc4433ab@linux-foundation.org>
In-Reply-To: <20251014194944.20341-1-dalalitamar@gmail.com>
References: <20251014194944.20341-1-dalalitamar@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: y1s8z13t5fzaug5tucs79ynjhezufu8u
X-Rspamd-Queue-Id: 2F46DA0005
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760477402-154203
X-HE-Meta: U2FsdGVkX19Abh4NCGIxFw2B4QKqu+HAE6CAfSjhNhr9i8O5Gbf0DLDyeK84+t4+iU5jaC1RtcwAid0y7gFUnIqNrAA+7Pa5IPKyOpIetnhaCoWzDXC0yBCs57R9C7bKUlGhr57M6UZWN3rIMmgZgk7E6aGmucjOFHKnMhLhn7IhgBW/2JxBtlO5sHN+fCzeSyHSG0vVsMcBCASp+OiUIohA7L6831nxjUI/Qqa/nEJwzVnbgafcctMeGKd0g2Xt2A6sFNvUPkvGJwQZf3HWDPWYZRTvcDKCIxpmhwxBRzhru9MOasg0nq0pb1dRGIUNu1looLVI1DiD6o1kFZ0Bruy3cxMb0Xb4K7Th9jZyXQS5WjdGIORtrD08jCfL7cQRkHEOiq/ixyJjNESLWX74soxwjBrtQZCSce3f88oENHOaulwtvieBqA4jlbLr+dVo0fefaeewiimJWySZE2sA+1lzFkGjXQg53xgjfUknfgOy43Muba0Dz2ycOOCEyhQi3LapuDcby20ZZ1xtkmtoBzd6wU/exEtgwh2tzJelMu/WE7fBMpp5hMhvKpB0f+VH/zTSl6XA9tjl95ItZ1eK99rqe5w7+10dsL9n2H234gMHRTLt9A+F5/ySJOOtTM60cLu/ZonmnZK2YsS+GjiuNWkIzV9X51qnQ6usDC6QxZ9XJ4KvikVEXvOvVxC+1lZQoouabu8yknrctwe2f5GnqEEEnFy6OTVlTSUaJnBE7tk8xeBDOcR2rrsmtI4KIOsgIgbWcIfiBKI5L0I1r6Tt5fRrcYNRmErmuX3z2GpSkBMNn4+jUNuem9yDoznuvK8MA9QiDyFWiV+r99rV/XyJWT6lWYo0l/v8dpYPc5WFp8vr20LMimU4d/LL2lBvV2pN2xJ3CtG20Jh8VnQNbcMN4PrdWzhiYPeGAl2AUazXBnrLkyzmrY7+onvpCPxh3CNsmi0edYEr7oVpqQ+kaFt
 cPqSSkiA
 B7hkFNXpWAad8vi35RNVrU0PFPGefcMCWVuHXQvYEMUNsaUPhw820FWU5U8zDanMtx6vZ94+kKPfYtmoDoCDQ20kfART0xsdnQ8LaisnBQVzGU/zjZYhyPmA1nlUSJWbRVEhUhRJwrORHLou3iGw9tZozh9t1/Yh7z+Ye76yp4l0sXkhAXNsmB9juZ69AlS4lQzGws5LxyB2yIH7CKWs15fXSEdabRx4sR51/qMxtGkXn22fQOtMUVDIt5h0PghxJIlDhPMZqouX+mTia7UALJuD8eqg7tTYll+9fLEAqb7k03mFe71nj4vmQwJt4/VM0u7tGm7KRP1EXWKn2tv6l+XXthuasF5Txwjt2gPXm0m4FuCAZtGU3csc+hGCBVQG0tgRd24z1KYPDzj2V1J/IXsf62FuUg62Gcl3MkHmMLs2+f733O/6KMYgWCyWU5cBYDKHr3WrbDdRBcZM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 14 Oct 2025 22:49:44 +0300 Itamar-Dalal <dalalitamar@gmail.com> wrote:

> Subject: [PATCH] Add a new test 'migrate.cow_after_fork' that verifies correct RMAP handling of Copy-On-Write pages after fork(). Before a write, parent and child share the same PFN; after a write, the child’s PFN differs, confirming proper COW duplication.
> Date: Tue, 14 Oct 2025 22:49:44 +0300
> X-Mailer: git-send-email 2.34.1
> 
> Signed-off-by: Itamar-Dalal <dalalitamar@gmail.com>
> ---
>  tools/testing/selftests/mm/rmap.c | 45 ++++++++++++++++++++++++++++++-
>  1 file changed, 44 insertions(+), 1 deletion(-)

OK, somehow your changelog was pasted into the email Subject, so please
resend.

Please prefix the Subject: with something which tells readers what part
of the kernel is affected. eg,

:
: Subject: selfstests/mm/rmap: verify correct RMAP handling of COW pages after fork()
:

Then enter the details in the changelog body, eg:

:
: Before a write, parent and child share the same PFN. After a write, the
: child’s PFN differs.  Check this to confirm proper COW duplication.
:


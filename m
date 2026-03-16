Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E720F53D67
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 15:06:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68FB06B02D1; Mon, 16 Mar 2026 11:06:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6675A6B02D2; Mon, 16 Mar 2026 11:06:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59E096B02D3; Mon, 16 Mar 2026 11:06:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 455B36B02D1
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 11:06:12 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0EA981C2C8
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 15:06:12 +0000 (UTC)
X-FDA: 84552251784.05.1FC1830
Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	by imf30.hostedemail.com (Postfix) with ESMTP id 41E998001B
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 15:06:10 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=lwn.net header.s=20201203 header.b=E8l7JUDI;
	spf=pass (imf30.hostedemail.com: domain of corbet@lwn.net designates 45.79.88.28 as permitted sender) smtp.mailfrom=corbet@lwn.net;
	dmarc=pass (policy=none) header.from=lwn.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773673570;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HcoFzXqKGZ4VRsUqh4N3hkFYaxdhCFRCFiU1h19xJPQ=;
	b=jtxS+rUgSfafxFrtYkzu2PzZ565IffMjKEHwdX6MVR9x/CmKotlGmES3+fSqpJicXlGDtV
	uON2WwIVqlk/+EblP17K1QEUJfCy478LlXkxBNGxqSUZ6oHDrj5Px1cqsAAiGtUWAXzQ2W
	Xaqz959HBxLBV3nnGkrGri6QgTGP1Dw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=lwn.net header.s=20201203 header.b=E8l7JUDI;
	spf=pass (imf30.hostedemail.com: domain of corbet@lwn.net designates 45.79.88.28 as permitted sender) smtp.mailfrom=corbet@lwn.net;
	dmarc=pass (policy=none) header.from=lwn.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773673570; a=rsa-sha256;
	cv=none;
	b=xvSX3V8Zj1BW6uAaAn2ae/ifhip6W1ruUhd2yyCq6mQMasKd7C+GFNXhKgKELoC1XFo7jH
	9vAzxWQBUNOH6WI30McT/cVN7XtjygQNNTP3tNzt6jqrs6L9sN7Xf7wFUGXwa+M9RWBsaD
	/H3PJ5+F98fRW5rPREVfK0Gb8a/qJdI=
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 35DF6411F8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1773673568; bh=HcoFzXqKGZ4VRsUqh4N3hkFYaxdhCFRCFiU1h19xJPQ=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=E8l7JUDI1f6yvu+pkh2/I8K3sWJ/9xBp565u1RQ73Z/RxP9mvn/L+GBVi0oomUVtG
	 G46+dbflomkdYax2uWBLoxPJxtEjEy3IsALd7H8Znt6UCdiya2WpCIlcKcF/HrqIx7
	 T63QjXI3HvjOg+UvMh1PVGMN82XSt6ZlBJPqZR24KmJ4A1+7SZa9CAa+EBSAt0y4yh
	 72ydQLOcQMtmvWtA/ZD5gtYdXsek3ClGmvd+qK2m9ITU/rCRBSoaJhhiuWfdm9rbNZ
	 akuRJLIivjMTWYpafuyQsvYqarif2AZ+QmCsk5AjtFVAFf1DvyMygGBfmdIfHDmj1Y
	 YuJsAhKCkeKow==
Received: from localhost (c-71-229-227-126.hsd1.co.comcast.net [71.229.227.126])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id 35DF6411F8;
	Mon, 16 Mar 2026 15:06:08 +0000 (UTC)
From: Jonathan Corbet <corbet@lwn.net>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>
Cc: Kit Dallege <xaum.io@gmail.com>, akpm@linux-foundation.org,
 david@kernel.org, linux-mm@kvack.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH] Docs/mm: document the OOM killer
In-Reply-To: <31744315-bf9e-4d9a-9c25-63eef0bd2f01@lucifer.local>
References: <20260314152518.100194-1-xaum.io@gmail.com>
 <fbee0ca1-4de6-4182-865b-a33d9ed32ee4@lucifer.local>
 <abeyD1ZngYhkAx6g@tiehlicka>
 <31744315-bf9e-4d9a-9c25-63eef0bd2f01@lucifer.local>
Date: Mon, 16 Mar 2026 09:06:07 -0600
Message-ID: <87bjgnizkw.fsf@trenco.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Queue-Id: 41E998001B
X-Rspamd-Server: rspam08
X-Stat-Signature: fbdm6tk1jyxhknwh38osidpeo1rajcd5
X-HE-Tag: 1773673570-985671
X-HE-Meta: U2FsdGVkX19NfZzmJP6ko1e3OzA11LZ6YnZ0l3ie2/QgFAAqcsAelDFk4+ntz74v0iy5CO5Tkt74In8huheqaQ7W3WcCkJ64P/VzjwuhSiaaj4iQk6eFY5zePVuRd/SJtN2X2KW2UWkUDIscUfoAjMKBwrJcwmAhCWml8EOMjTt96+Wit5RfBEjZiON7UJKQcpGtH9Hu+sPCYQ75cgHBrKfixjonGQQX8hD3gQFHja++mFkC2C/AmWtQWSF7DKZLryAEgyB6qr1nT+MyrqwTJN3xyBVxuQhcKsx0iSE6l6KKG2ASXlm66ubyTA2ayAfTVkF7rlfLp0FrfaQID6nS+kA4iGzEGZhkj56pXbRzqIOtXUaGovX9NdjzSTGBzFxU7LLdHgf6wX2bBWuuW0dVZMsbAoM3B7zsTuhjQNUl70TF/T+W2KYrK81/ZZvoHksILV6P15fkyCfD3GPR96HLXuvHK9FXTAZ5UAc4iZvBQlcbRNIgvBTOEtOZyhJ1xCdsvaPD7tj1+2Lc6h0tQ7wTYDISPG2jDTqV8gJPH7Ou8iMFmLNXvBBA5vCJ4Kc5Fa9Q/aPdoGv/bPS7EHZ+sAcmIpq4ch1H08M3X/i8TNl2MTG7AGc2wGEodrFD0WJLoRCSTDe+V4SraJQPP5bD2BnwWfj5UISBTTx5BOsZEYV4Nj8W5+Q52OvlhsrRCBMQC28uhhYDJeAmVOGXTXAaGqEewPh7gww4VW+2lfPbODGDYwmXeTRUpi1aA5EHRtAYN4q1jVXjV16+EEIzqnkxjcfkjLZINbZYO5SJDm0k8hI5CBCQNctgDAuwIphVsbX/fWtbjcO2fQT9/OR/sFur2RALS7FBvDb58zQs/ZY3yTPqg4sat2ToFI97cpqj3HEV2+yAlDVFrqRqd+6UsiBEfyMjuPmpiBeZjMDjVmzqsA9DXBb8zKdrZOGw4+DiiivD3Mfd6cNiEY2KqQ3OpU+TbAm
 avv1nnWL
 Z7hVoPrnDTG9o0+NndBafvWPkxcPsKloC45MRZMmbW7NnzCc3KFjn829ie70thAL2/QXIaUVeMhuyvsekISrbA6Q77GhM1yQuub4t1XyEQzWNaNZwh/ofrvqMTbFQ1CUJ9TMkxnHR83tENaBPDYoGZXUcm2oaVa8URONqeh0PP2uXmI5skel9JFv/+DEjtfK1RXVuMXH/wMrN1dIWCkfnv1zgdENT8zCyIRxm9KMRJy6+V7JhWuLTDfNCSttqt4yCaUdxoi7Z3iIkk3ju/se+vJ/DP9sYNkEk6tNv9r6b/jb2zmld2eEc5Ck0dwzTQtZYp0TWqMHNtp+FN7V3b92vw5LULAq+9YdE2JMH8Uqe7HlKWHg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Lorenzo Stoakes (Oracle)" <ljs@kernel.org> writes:

> I wonder if some of us (I realise this sounds like self volunteering)
> should just write up some bare bones and patch it in, then we can get the
> iterating part of things moving?

That, of course, was the theory behind the addition of the skeleton
documentation that's there now :)

I have also thought about trying to fill it in once a bit of spare time
opens up.  Funny how that tends not to happen, but I still would like to
do that at some point.

Michal's question, though, is something that needs a good answer: who is
the audience for Documentation/mm/ ?  Some of the stuff in the patch
under discussion, if it were to reach an acceptable point, is probably
better placed in the admin guide.  OTOH, a manual firmly aimed at people
trying to understand the MM code itself makes sense to me.

Thanks,

jon


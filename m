Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5EF3CCD19A
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 04:33:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D7278E0003; Mon, 17 Nov 2025 23:33:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 287F28E0002; Mon, 17 Nov 2025 23:33:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19D0F8E0003; Mon, 17 Nov 2025 23:33:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 064488E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 23:33:56 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CF12712E7CF
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 04:33:55 +0000 (UTC)
X-FDA: 84122460030.29.6CEB46F
Received: from mail.eskimo.com (mail.eskimo.com [66.114.134.197])
	by imf14.hostedemail.com (Postfix) with ESMTP id D7EDF10000C
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 04:33:51 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of nanook@eskimo.com designates 66.114.134.197 as permitted sender) smtp.mailfrom=nanook@eskimo.com;
	dmarc=pass (policy=reject) header.from=eskimo.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763440434;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pJ4kIf/49p68w0trrAztEvNzS63O2+i/tU69OUx8m9Y=;
	b=2HFWkHiKMhjBndfehNKzDs92hy3vyvo/MlV+3Q/vyalSTwbbDb/JmElEcEHIRQg+U0TqaI
	j+kDhhfaMjx1JfxDS0JUMBiT8lqEVrhJPi3/NYG64yH/+jyHfYZbBozJiWiTFTERWHvzEW
	yzl6VCMvHsmG+4dswVFWHVuzk6JFHxM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763440434; a=rsa-sha256;
	cv=none;
	b=ceMkovS7kZsVnaGnbfxvxFPVlOAEgpXT20M+3cDgjk5gFF6YA6Bwv4f6OW6b8UyGgy/bcM
	o9YDc9muFjleQgbqPeYrTrYT5TURVJJk5nSOKfZtKdzXUlmu8XDapGIP+B08jAx9pKxycK
	LbY6HpRe/GHPWw4LGIJGmzBZC2c8XPE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of nanook@eskimo.com designates 66.114.134.197 as permitted sender) smtp.mailfrom=nanook@eskimo.com;
	dmarc=pass (policy=reject) header.from=eskimo.com
Received: from ubuntu.eskimo.com (ubuntu.eskimo.com [IPv6:2001:560:4407:1::106])
	by mail.eskimo.com (Postfix) with ESMTPS id CDAEA3C2AC7;
	Mon, 17 Nov 2025 20:33:49 -0800 (PST)
Date: Mon, 17 Nov 2025 20:33:49 -0800 (PST)
From: Robert Dinse <nanook@eskimo.com>
To: Michal Hocko <mhocko@suse.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: Folio Related Stability Crashes in 6.17.5 and 6.17.6
In-Reply-To: <aQxl1sXTvhIB753a@tiehlicka>
Message-ID: <9c9b73d4-fb77-5a94-ea33-6a232f1b7e8d@eskimo.com>
References: <b964df0f-45e3-4fea-a84d-852869b49502@eskimo.com> <aQxX1HdOnVZJAERp@tiehlicka> <41d1cb48-7711-690e-c9a2-978e0f96f5d6@eskimo.com> <aQxl1sXTvhIB753a@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
X-Virus-Scanned: clamav-milter 1.4.3 at mail.eskimo.com
X-Virus-Status: Clean
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D7EDF10000C
X-Stat-Signature: twujyji67q6g4zqjmrrmj3ux843q8j7y
X-Rspam-User: 
X-HE-Tag: 1763440431-537447
X-HE-Meta: U2FsdGVkX18HK+G0cWOBSERiaJcje4U3B5DMPp0uCyuRg2FgJkxmKAsxOP3iu1J4h+V/xsdyUffD3TCqvC+I6G4GKW7e4Gp+YmD3uBtdjwvV0kE45vUwK7dCKLpq5Etug1/0G15TpmHNsXuw9o7i17I/GWntWzBCGUgqDVARWTv0eGNSkHYK87rEaWfSpZzwHQ3qHCaI+QWgDBRnd99RlkjcWuIWSC0QiAxJXKRp/xBL/swrNblw1lHyYWFt/GnpwDJv1WvhUO0IUxaTuraMwOG7UwA7O/DP8KugjxXQ9a1xhRuQ4Y/vEmwiFqXPRMu4SN8i3hjVk1nvNO/6Or2rY7j/o8s81pao7RGk4LBBmDQT/rhiuKWeTtsVMn7QEzCMVJ/G0kgflKJXna6HkWhR473jLNZWvyr54xCnCkrHabpNh0LAk4WWzEgw9R+HUMQBCGfJRGuelz/fkY8ddb55pb6By4tEwPRMN8Zl6Zf4uXySaOuwF+giZMAj9G7mic0cEOCgXAdebxtBRb6vSioA46iKAPAIKTp0sJVJNT+aMf6sDTMAPwNgLGJNv4MGjOEA2R64zyDhHwaDghWeVVipSjgvCCOMUnxb9YKMptt+fCLmowVc5teC/Ie5EyZFNSYWFIf0Wam5P6KBO9HdY00G2Pl9FJN03WeYQDgG+YDrzrnH35wIec8VQhQl5cukvSqY2fJV0fIWn1TFGdrjMCkXqmpU/VsROrVX8q6fxlrgZs18MjHDTl5M5vHNugPlRpbly22vobgla9Un4L5EGj9UH/faXsg5Gp+4HiOIo9hY68Gi6Xb+BTk/M5wZcyyS7D/bYWeosEulloKL/mrUlQ9px4Dq2BXlgL8UKSNiJJ0CkrXF2KTmB6afGX8JFYJXc6o5GMzJGliSjrS/0hdzjKWnD+QVGQ55QW9JW4URPdbr6ZEQyWYgD0u1QX0ctadctT7GSCTVd64J1udD/3JZLsu
 IiSigfcf
 exl7QjVR9TD9i5cB4mHilWhaqQnrVqVnx/CvQRoAcWgESLn8dLpRHtBPF5RJbH4noeub4EG1NqkzJSDeh9GJ1srKjPVlrlKJOIMAgGulh5ItP7VyQlzsynUgcYwLfI4QR0JGUhP4EcbmEaa72ACrpZjwquAZ8LGgOtJIZwtbd6FxjeUcLe9PXmLldOT5/9fPrPcW4ko57fqWTi7ywt/2RFM91IE922e1hA07xb3r/iIcSZzZvJMKULe4WvemF0buX7FNYdjrITpqU7fQe4O+b+hkoWHpXDTFugQ6zqipEt3qo276CaAoFEUT1c+ZTs6algjBh6SP9EsxiSwhgmQLPrAxvzfh/prRJaSc6K0SQaZ8i9j0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.001035, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


      Just wanted to provide some feedback, this was still a problem with
6.18.0-rc4+2, but so far 6.18.0-rc5 has been stable.

-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
  Eskimo North Linux Friendly Internet Access, Shell Accounts, and Hosting.
    Knowledgeable human assistance, not telephone trees or script readers.
  See our web site: http://www.eskimo.com/ (206) 812-0051 or (800) 246-6874.

On Thu, 6 Nov 2025, Michal Hocko wrote:

> Date: Thu, 6 Nov 2025 10:09:42 +0100
> From: Michal Hocko <mhocko@suse.com>
> To: Robert Dinse <nanook@eskimo.com>
> Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
> Subject: Re: Folio Related Stability Crashes in 6.17.5 and 6.17.6
> 
> On Thu 06-11-25 00:24:36, Robert Dinse wrote:
>>
>>      I am installing 6.17.7 presently, I was a little resident to install
>> the current tree on a critical machine.  If need be I will.  Also, I do have
>> a crash dump on the last failure if that would be of any help.
>
> Understood, I am not sure who is going to be willing to debug this on
> top of stable tree if it is not clear whether this is a problem in
> vanila tree as well.
>
> -- 
> Michal Hocko
> SUSE Labs
>


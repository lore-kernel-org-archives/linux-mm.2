Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DED04E73158
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 11:14:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F13066B008C; Mon,  2 Feb 2026 06:14:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC0B86B0096; Mon,  2 Feb 2026 06:14:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF6F66B0099; Mon,  2 Feb 2026 06:14:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CF7DC6B008C
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 06:14:05 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 83AED160B65
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 11:14:05 +0000 (UTC)
X-FDA: 84399257250.28.5A35775
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id E555B180012
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 11:14:03 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gJ7L66OP;
	spf=pass (imf24.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770030843;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CbfvVs0qu7Uc8AuPw+57sFfgDNE6r6zOJCt7LaSliKs=;
	b=elPk9evM9S626f+CwH2DSu7GVU5rXdKUBN7DAIxRJpuWQO9eJ8BXWePgG5eRR9l4MvEHEz
	MVuAN7311eCfQsAbpwXx02+hYdqP2HMRQTyLvq1kvvyjA9mPwB3VnF5QG2eNOL/5+hdfmn
	cRwL4wpk1csZ/nYGgUPrkrlXzCVFDHU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gJ7L66OP;
	spf=pass (imf24.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770030843; a=rsa-sha256;
	cv=none;
	b=BBsBJA84jNTdw8+8y46ShtRPHCN46rGSgI/Xlz8BxoTRCfb9ARCLCD6IBHK/S3JKWEvpnP
	7Aiy9tZ2kGbeVM3JtcULdNpMSP+/WITsBFKnq/s2FFFCMcaIQXzDKYzgYsxMJ+c8m+zUMC
	e8843dd9nbonmye6M6aUGVhACqzYlsk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 19EFC60125;
	Mon,  2 Feb 2026 11:14:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA24DC116C6;
	Mon,  2 Feb 2026 11:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770030842;
	bh=gdslb81gtLt2TMFtb7dneZ/Ac6aZj0W0zEgWfWUAcU0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=gJ7L66OPr1yuzQpNxQQHYwTEkgzE0OARBNuA24P8pJPlZrtl05mzoGkwnqzIR37Z2
	 Sief+o2UwhkzAKhSKYOafVOaHNJVEzdsB9lcBBLK3XwQ+0aMOY1/pY4XmmDgVIUalt
	 OKL7B6i6GBg+hIGESmchrf0FoIIC0cg7LK+LetnizD19pyO6Rd7KwZeoRFRX25Exkk
	 iOnjyKsyP/1gK+MgZOQFhfdKUBWx4f80gJw9Pk8PpgugQhrA+ElMiyVU7xdOtul8iA
	 0dEkuXQlTku0J0Eu67IigULEf7S0b09/UmCbdDtWiD60its9fOm8OAZvlux7QXSFpi
	 JzXnxSmkzTkXA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Mike Rapoport <rppt@kernel.org>,
  Pasha Tatashin <pasha.tatashin@soleen.com>,
  linux-kernel@vger.kernel.org,  linux-mm@kvack.org
Subject: Re: [PATCH 1/2] liveupdate: luo_file: do not clear serialized_data
 on unfreeze
In-Reply-To: <20260130115004.b530155b27d6d15929bcfa63@linux-foundation.org>
	(Andrew Morton's message of "Fri, 30 Jan 2026 11:50:04 -0800")
References: <20260126230302.2936817-1-pratyush@kernel.org>
	<20260126230302.2936817-2-pratyush@kernel.org>
	<aXnwvkuTBL1NLt7f@kernel.org> <2vxzv7gj7wv7.fsf@kernel.org>
	<20260130115004.b530155b27d6d15929bcfa63@linux-foundation.org>
Date: Mon, 02 Feb 2026 12:14:00 +0100
Message-ID: <2vxzqzr38kjr.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam11
X-Stat-Signature: w558wpick67cr46qc3o48cfe7os13wu4
X-Rspam-User: 
X-Rspamd-Queue-Id: E555B180012
X-HE-Tag: 1770030843-997802
X-HE-Meta: U2FsdGVkX1/XIMhXdp1OXnNALfWH5SqSZr78p2cg9uqK7q8U/qTc2FqVJ7Hed7gWdfDS3Bb5Lugr0jbksUEQTGpV5s09BgCdleBuAsSoUP0EynbFC9Oz4odmZYBQmBMcYx9YxzIL9tXLcOKlYJMYN76JvqSrhfBGp3DwwpgXQzRGBeS+q7vMaSmH86KaWpD2+3l1OEyIn6lrQah2YP+Ad9NZ4u157k7hOkHe6gkC1kMtLf+rBNjfkkjCZWMKb2cufG2iCgwgcrlkYuGQ8lyJpXyvqbKjSz8VbkO1vnRrldnXroHdFdXbVSCvVOPElosa1osBduTnfTpE7QtF389ozH4XlCWrFymyeAdnumy71Z0KpywkC/RJmJeRKfQrcHuWb1XZiSEtpep+tdXSWxGX4cVDsUgRsWsFhTvWBjUaZtvc6/jHDzWu55i8uYu5gQKc4ZfRTyX/wBwmxJ2bqHT3qF9qGBTCRvpdYn9yKb0CKhlwXO8Y86KEY1hXu9l3wVs0dbCSoVkauo3pvvIBuY/ni2OIQeYtM/tnUXRbJ/0ILLkASsmHxbvUPORoiA53FiClOaClVN9+tQEo7OOQbIji2mDe6+9YcOPZUTNsy86fedhLSsc3xJ+/oxg0I7p6nw6r/KkkH6+WhyjsdjxaabqkSbB/QT+/+so4DptKsBT7Z63wBsuCUA5R6+V86DhOvUjeHEFQC1G3c8H+dujpFNaWw33ymebkmUYQjCq9EOOAT7sQh8+hKhwn2gHhQdMQlusRUwFjXhdOO2SOrP8+89uD0nu1nQh9ZoB1cWL12wfmO++IO/8XHFHjoSwJOwwKDhPuXs30v2ZAQUV08sjTx6KmrSoxZIJXUoGoC+aEhCdr8R2SbaA8FTfgH73GPcMRJxX/x2kIxmSOG/LJyd8c7zyzrO8DmWHfaNBC4llkYpWCPNHmvlW3bnLgVcs4c5Ucg+T3ePq6NiFFHPppolkVVZ2
 wQbd0Ei0
 mG5WOFUKKXYof5/KPk8WGKqfbXp4wcE7lzLnKYcQii6qFppfrExuftLcROHflbMNSN7jIHu2LxCoatbhWztLc3mm8l6PCWrjnhzebPld5UUQUyisVvm9Rs4ViToHsfVIaoSBnrjivaTQPob3+Kzh1rrfEg8jHzx9rS6xYBtA6ODD29N4w8EC/TFhPcK4x2LbmgXGoNsLB69jT1ggAXx2B7oVjLzDTgLjbeCIuI15NTQTxLLQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 30 2026, Andrew Morton wrote:

> On Fri, 30 Jan 2026 19:56:28 +0100 Pratyush Yadav <pratyush@kernel.org> wrote:
>
>> >> Fixes: 7c722a7f44e0 ("liveupdate: luo_file: implement file systems callbacks")
>> >> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
>> >
>> > Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>> 
>> Thanks.
>> 
>> Andrew, do you mind taking this patch in v6.19-rc8/v6.19 hotfixes?
>
> Yep, that's where it was.

Thanks. I didn't realize there was going to be an -rc8 and I didn't want
this patch to miss the final cut of v6.19 in case you were expecting a
re-roll of the whole series.

>
>> The
>> second patch needs a re-roll and I don't think I would be able to do it
>> this week.
>> 
>> This is an independent fix and I see no reason to block this waiting for
>> the other one.
>
> OK, I moved "liveupdate: luo_file: remember retrieve() status" to
> tail-of-everything and added a note that a new version is expected.

Sounds good. I'll try to send out the new version in the next couple
days so we can include it in v6.19 final.

-- 
Regards,
Pratyush Yadav


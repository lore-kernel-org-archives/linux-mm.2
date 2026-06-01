Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 848E8CD6E55
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 15:01:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C85A76B03F9; Mon,  1 Jun 2026 11:01:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5CD36B03FB; Mon,  1 Jun 2026 11:01:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9A4E6B03FC; Mon,  1 Jun 2026 11:01:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A78EB6B03F9
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 11:01:01 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4B6A8A0707
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 15:01:01 +0000 (UTC)
X-FDA: 84831656322.30.BDD15B6
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	by imf23.hostedemail.com (Postfix) with ESMTP id F3B18140025
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 15:00:57 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=pyMrlwCt;
	spf=pass (imf23.hostedemail.com: domain of chizhiling@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=chizhiling@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780326059;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gs1LnQHwscIGOezLFRdkXnucnz6eylm4BeP9xClXfcw=;
	b=5g+TxQVwi8TEQzMLJZKkgvYvztUzyKeerg3Kd80zfvyfrfIctGbjIHZCvTAQA8iAaKsarU
	YTr80+xGbukdHgtdydYg0TUzFHokMsHkrW934zAZxxcRsWRjgwzEh/e/A9lUjjCCOtXtJn
	KY2SA03vdGOew+p4OK536dBTbK6hvgk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780326059;
	b=OVTXXFTAFcnpupEG71vF82II43qXHLnNTdTz0v+9lbJaDZm/p2Boa3gWMCYTkpL912jCX6
	CjaCCDM7ORjaohjlxApINQZqaa10n7ON2u7R0TdiLybnl6PieeWx15bZ05y/pB6bKGuPy6
	sI9Cx+Z5Lo19FYNLxRBlZ/v8Fam6CT0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=pyMrlwCt;
	spf=pass (imf23.hostedemail.com: domain of chizhiling@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=chizhiling@163.com;
	dmarc=pass (policy=none) header.from=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:To:From:
	Content-Type; bh=gs1LnQHwscIGOezLFRdkXnucnz6eylm4BeP9xClXfcw=;
	b=pyMrlwCtkrR3IwqfKd3dRm0ws7iTb7jxKulkntCU9nuTIenpcDtTPEY+bTxRMf
	LhaI7TWZ/AClxIjTKhpPw20G2ppc0L1cNiDZTmaPzc1kDPYvbJ9e7DYBYIuaQMFF
	m506Z+HEN3NXzszU8+YJOYkfNz9VGKz8kEDKelpWylSe4=
Received: from [192.168.5.171] (unknown [])
	by gzga-smtp-mtada-g0-4 (Coremail) with SMTP id _____wDHj1iQnh1qRxFoAw--.64263S2;
	Mon, 01 Jun 2026 23:00:32 +0800 (CST)
Message-ID: <a5a3b691-0613-4731-8850-1cfadb5afbc3@163.com>
Date: Mon, 1 Jun 2026 23:00:32 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/5] mm/shmem: optimize file read with folio batching
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Chi Zhiling <chizhiling@kylinos.cn>
References: <20260601055704.167436-1-chizhiling@163.com>
 <20260601055704.167436-6-chizhiling@163.com>
 <ah2QKCFWdzXIW448@casper.infradead.org>
From: Chi Zhiling <chizhiling@163.com>
In-Reply-To: <ah2QKCFWdzXIW448@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:_____wDHj1iQnh1qRxFoAw--.64263S2
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjxUYL05UUUUU
X-Originating-IP: [58.20.13.92]
X-CM-SenderInfo: hfkl6xxlol0wi6rwjhhfrp/xtbC+BCtS2odnpAZBwAA3p
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: F3B18140025
X-Stat-Signature: 314yrdmpb95qfprpdto6puaex6nuiiji
X-HE-Tag: 1780326057-977392
X-HE-Meta: U2FsdGVkX1+wWhg7RatGoPfnhFpBIBp250M47uNQnG5f5w41fUKlKifMq54uMZn7tCrEbeQj6XzmItYGmEMRdrt3/uYFFMQipjj9k8SZqqOd1fscm0MoD/BtnzBjlElCGb2pLVEPrRkcsXEoiN4oSVIkMMwKVmJ9fxZY9mUn3K0uXPpDUDtxLFATD53K800ip0AHEMEHwsulZ6hDZphiRvVErO5OCUsBFeibyoGsactsfuyL06FFxi4/JOsq0SclX5lLXlrJEb4KB9NkBpv3Kn9vZ3Q2LwOwRfbz+4rrVLb1H4NsjLKU9Mgu/m5U8+9OZOqyIIdkjLR2Fp/KAb6uEX9X4CFP8KlioWlsGkhesMm7abMHgjCWl56YTNUUH/OhRh/0lNKWGwDIES8kTkfyZQGP5yajDRh1c+kXpPfshv8gFZhSFHm6rHJtQaLeT7vtlrqaTlBI4hh0CzaIiGPGcTVezmXDG+YEoBH6fcCIGsNgwQyAymSwL80pEBRZOeSEmREhGXvPd83ZmNEHbqL+CksjWMP8KIFGzV85MaYdnsQY+JqMJHFaYNQrI9aWBQNTNfglnqWLbio9C7Ynt1vPtTBDTweIq7HnIGOvpZyb3/0MvLWMbQgmHyx31bDbCpij6lS75iPV20DOkB4hftNovb+I/b+KLe0/GnbpfQReJpiIt+fAJELjE+BS2qnAucJl+QDoV7esBxdAhTpXz8PoRpfP/ndHcg66CcNW0N1n6MfRO7t4z1Aenq9Uhv/QGQuQx6jIn3rRytA/zT8gSMR41cYR2hx9dMYq2g8/eb49pTQkw1YXiapNlKSnBSZRTv4pHlzr9H+4fHovhvEvehlTOreD+DY0Nx+PTIoI7t4wCgy9/naqMwoMiMuOvLFIR6UhrwftYXH2/XNLdAx4rlRDn77ffovLTqDWEHJYQph7dTdBqMEEMbZ+Juwt022/dyTDodu60I1NFxhSuaTBmbT
 DWZHu6OG
 mXdU53Wl08IEiA66nT9YXZMB0kxEiCMM97/QGrdi5XmJN+mYRyUmManbzHneGI3+1ezTIKFqtm8iMCj3sgvUicUgLHfqP+823l1v03t312phbsJKhezNPEJqqK+AaxAqv/zcBXAyEPxnzT8SIHphSGM/cIo3GqBdroHlDoJd3erDbYxNEsNvdONfMeD/+PEZ3MkF68iMbCJEsttAv+tfhAage96IZc/MOrVLhSrVOyl7I3QjQt6EAXWuixrsyPQ1rkEo1cmpItfydDnKU7X/H0fubvmMmUC2J2LxQBb9fjhYjrZJR333Hm3ygmV9fYbx9gefY5IVen3m3zyBCcKBaNFpG8Ebme6fJSmwB+NWjRp+f+IufRK98d2yHJ7uynHqi+t7l
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/1/26 9:59 PM, Matthew Wilcox wrote:
> On Mon, Jun 01, 2026 at 01:57:04PM +0800, Chi Zhiling wrote:
>> +			if (folio_batch_count(&fbatch)) {
>> +				for (int i = 0; i < folio_batch_count(&fbatch); i++)
>> +					folio_put(fbatch.folios[i]);
>> +				folio_batch_reinit(&fbatch);
>> +			}
> 
> folios_put().
> 
>> +	for (int i = 0; i < folio_batch_count(&fbatch); i++)
>> +		folio_put(fbatch.folios[i]);
> 
> Also folios_put().

Thanks, I'll replace it in v3.



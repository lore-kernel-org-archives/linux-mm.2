Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81F55C624D4
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 17:13:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A75BB6B00EF; Wed,  2 Sep 2026 13:13:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A26396B00F1; Wed,  2 Sep 2026 13:13:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 963286B00F2; Wed,  2 Sep 2026 13:13:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 73DD76B00EF
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 13:13:48 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0B6E7A41E5
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 17:13:48 +0000 (UTC)
X-FDA: 85169469336.13.EA39992
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf31.hostedemail.com (Postfix) with ESMTP id 361CD20008
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 17:13:45 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=PsRDGgd7;
	spf=pass (imf31.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788369225;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tPYPDYewNeawBi07p/nAs1ibrnpGT5ATVl7N1IHg4KQ=;
	b=ZVTpIxssaQOl7k9EoQyjFUs7wyucfF7sxKBc38iakslw1+mo9TDor6bRG02cDKJHklJ3i/
	iMTi0LEP927atbWS8kaN5/50JYnHBwV4fmVoD4S6EtK6Y06M/cT5/lqdDVqc1Eyy0Thj6u
	sgjPq/ghRIkEgLrEUjcc+NcloOA/v84=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788369225;
	b=eEsi5hq/Ph0ljL/1FVAqgKYSIGnsKX5+BXFG28WcPPzsEVaBnU4pkghKBdxST0PuPytakb
	0sJ53KHO7xJZ5sK+OqgWT9rawVF02w31yLDEGUP7qLPa7jNpBB+zvR6pcDWMJx39AWGsrQ
	JEcmbcsqYRfo/jRLHOBp3wcw39K0In4=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=PsRDGgd7;
	spf=pass (imf31.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=tPYPDYewNeawBi07p/nAs1ibrnpGT5ATVl7N1IHg4KQ=; b=PsRDGgd7vGLOAFVuJrqFJWrV98
	0tjx9MzA56CZk0CQ9Iduswwhk73iSP37LRiKXrX7S4hmKECQ97qJLr9B7AKNwiXyOzirfkVc4dNLh
	Oqeb84I4URhLK3vKCocw86Ht1T+OAs+oIurk+ssjJZGWhVpYXfjoxxo+XHlxZmdxO6k+DgdtaRZ5r
	CtYnuS8AUH/AMwYUZ8g1ddjYJUxRTs1jsyG6mJFLmLc7LkuWViqqBzYS5/L+ZSKWD6Y5yjkZ+jM40
	iBrirKdew1l0TKEW2nf+ihFWZEXpwoPsxxax3wXKMReQFztuoEeQkpdeong/65tdMapiZWIN81Mie
	qOv61AKQ==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x1oWr-0000000FPZl-3jei;
	Wed, 02 Sep 2026 17:13:41 +0000
Message-ID: <e0c0ab31-8f19-437b-b8c0-3ed6963e9064@infradead.org>
Date: Wed, 2 Sep 2026 10:13:41 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] docs: locking: Fix bracket
To: Jan Kara <jack@suse.cz>, Manuel Ebner <manuelebnerli@mailbox.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260902143936.703665-4-manuelebnerli@mailbox.org>
 <ffoup27vuua4yo5weeyhgdjevtb4c2nkoz45lkk5kzipnnhzsn@wckefd3i2vv4>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <ffoup27vuua4yo5weeyhgdjevtb4c2nkoz45lkk5kzipnnhzsn@wckefd3i2vv4>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: oru4di9x47hnruucysxcttczhbfkuhtz
X-Rspamd-Queue-Id: 361CD20008
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788369225-932639
X-HE-Meta: U2FsdGVkX19HHCqtYXmzTki2mCGekzbYc4LzkTIcde0rkyZwucZp2bcsrl1v6a5oGXemKRYeefwzE9NJmiGIsQqk/TMDXr+jQCITfW8AbB5lUxD93D3PUbfsr9lEbiaHIWMSduyt04jRx7Woz3tjOE7wIB2fPTyOlJlsFmZ/NO8qUS12OL8SejIf9RlFmanZZc5v6jNpnHImTVPRb6HUKVpwe616Ayeg86r70Gmp7WrDhf2q9Egv6Clk1fwYHIpwIfO56sl1CSYJaSJQBVdPjG/1R+1kLkG6bJOsxWytkRnVcL9UhUeYsDipSdtODmz6fLR7AGEiJtFaTKInEq8vVf0oAtas7ora0+IMK7A3TEJos0D9t0wule9W9CE/R6dzuMhYs/5CQ93o5J4GS67CJcc9qJZ/rg09w5L6BruPSTMtwveEV7Fc9kCSEMMrNIyNE9/vWE4xM98ovgQNU3+4twHGvnyfmXwIAfMvauYeTbFKVAfZ2mcLMsshr2tnOQ2ySCAl85IX2R6/H53uslbqDGxxSknhn2I7OliuocegTSOIN+jN1hXHOy/skNblxLbZ0ZySv8N+hDEiAMPlGlhXl2zebjLfui4G5ZSWC4Yr3XMo6/zoMyRrSflxyW76lmERJGHeoY46Y/Ejm+x4Db0aLlG8eXk34VtDPLwa89w4DE0xBUQht0lvyfMJs0sMjj/N9/Gj6aFzn+UCL/DM1LVy9qd8SNr3chicDx3SeIU1NkXb9AYbxYVye5sFAJmnn4RG72iEWHMWGzOg0I5WyYCBKJHcUKCtYZdoBe4fudIolIcB4kIuCN/lWnJnRbsAv4ZCit2HLfjHCIRnZ4jWWeCPn1YWSaQ6u9YMLEV2WBYHUojrQL1VkNT+xv5HwwJp9DtbOFFu9xM2Azr+Gas/eNvXseUTbVjQjNDOqK87EcbvEFHq92rarmLEhZwNOusM9UksrkOfG9q44OAQX9bpnkr
 Vo6lYZQ+
 Dmggv1OVtllq4wXS4bs0tJ1lphAhnbrXW7fC/nJ71EKEK48JW34w5x1H58k++dwy9kHfsPHxoRBKsP8yM7SQiPoMAHAbV5c+KamcZn8ALReRsbA4nK46nLRQ2FyStrEEgxfn9HgYvHOw+H4SAXlT2qcXjmsIAMAZ3qgPREUtD0dCsd+mMxWh7aLPMCOwh0QQ3XYLvHbnTQcXuUYQCCzBg1P+vDfYMWlNXhFleavr1O5AxitHbB5y+cANV8t2ow6Cb1eXqerLF3tdCYgvBmCd5yzuFQ0691ED5p07ZPyzL8uLdcQF+E5MRYq+r0GmyEOp+SpYe7pQx0GaG8IrI+5yoZhfGJIVMpJrDn6QlWh/j3KFuY5hgfkhOc0E09OznJ2d3/BYifHGokR89NSVMESei5BRHWw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/2/26 7:58 AM, Jan Kara wrote:
> On Wed 02-09-26 16:39:38, Manuel Ebner wrote:
>> Remove needless '(' from code block.
>>
>> Signed-off-by: Manuel Ebner <manuelebnerli@mailbox.org>
> 
> Looks good. Feel free to add:
> 
> Reviewed-by: Jan Kara <jack@suse.cz>

Reviewed-by: Randy Dunlap <rdunlap@infradead.org>

> 
>> ---
>> Should I also replace ')(' with ') (' as it is in the second code block?
>> It would improve readability in my opinion.
> 
> Dunno, at least I'm used to the way which is written here :)

I agree - this looks typical to me.

> 
> 								Honza
> 
>> ---
>>  Documentation/filesystems/locking.rst | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/Documentation/filesystems/locking.rst b/Documentation/filesystems/locking.rst
>> index 844d65eb4..1598cf555 100644
>> --- a/Documentation/filesystems/locking.rst
>> +++ b/Documentation/filesystems/locking.rst
>> @@ -27,7 +27,7 @@ prototypes::
>>  	int (*d_init)(struct dentry *);
>>  	void (*d_release)(struct dentry *);
>>  	void (*d_iput)(struct dentry *, struct inode *);
>> -	char *(*d_dname)((struct dentry *dentry, char *buffer, int buflen);
>> +	char *(*d_dname)(struct dentry *dentry, char *buffer, int buflen);
>>  	struct vfsmount *(*d_automount)(struct path *path);
>>  	int (*d_manage)(const struct path *, bool);
>>  	struct dentry *(*d_real)(struct dentry *, enum d_real_type type);
>> -- 
>> 2.54.0
>>

-- 
~Randy


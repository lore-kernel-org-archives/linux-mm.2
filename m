Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 838A1FF8867
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 01:13:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED2FF6B0088; Mon, 27 Apr 2026 21:13:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA94B6B008A; Mon, 27 Apr 2026 21:13:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBEDE6B008C; Mon, 27 Apr 2026 21:13:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CDDA26B0088
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 21:13:04 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 922991C0585
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 01:13:04 +0000 (UTC)
X-FDA: 84706190688.18.84AA069
Received: from out203-205-221-242.mail.qq.com (out203-205-221-242.mail.qq.com [203.205.221.242])
	by imf26.hostedemail.com (Postfix) with ESMTP id E267314000E
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 01:13:01 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=UGWG3Oc3;
	dmarc=pass (policy=quarantine) header.from=qq.com;
	spf=pass (imf26.hostedemail.com: domain of fujunjie1@qq.com designates 203.205.221.242 as permitted sender) smtp.mailfrom=fujunjie1@qq.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777338782;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TNukEp4Dwl+Oqc1T43hxrWXMq55wH2a1IStVIx5h5BU=;
	b=Z8tpW/dJix4V8tX3PGZh67l3HSIJJpuniKWHT1De4b4m5aLSAMykCA40sJGK58+hsotes5
	jFg+sCwNZX3qF4bPmk7zYXfApm6PV4QPYL6cI49yFFtd1pKNdm6MHGM3AoLOJkCXJFyfIP
	0DamciCuapdW+snxmzW4f2oVv6Udc0w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777338782; a=rsa-sha256;
	cv=none;
	b=wH2LfXBBkq7jFMJt6Uz8HeYLNW1fq0JNjGG/lHoYJpLVCg6qDzwWGoh/Wb/pxLveXAE68w
	f5ekeGLwRBSzcxf8BOGgF+CkL5Dy4edUm270JVX+eryKdxKDUlmMTbGEzQDPAshBjDu9tE
	XXVOdPiWzpgYoVb7r+lvBfl03T5/hjQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=UGWG3Oc3;
	dmarc=pass (policy=quarantine) header.from=qq.com;
	spf=pass (imf26.hostedemail.com: domain of fujunjie1@qq.com designates 203.205.221.242 as permitted sender) smtp.mailfrom=fujunjie1@qq.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1777338778; bh=TNukEp4Dwl+Oqc1T43hxrWXMq55wH2a1IStVIx5h5BU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=UGWG3Oc30SsO1zquk3Oaj5qOx9LwKsuRD+FfbxQ64Q3lnYQJQb7C30I5DnMyYWcfM
	 2PCBmRcoWBL6rbHKUnlbrwXHkIePwJm2QTppzXfkH09ZDcI7pT7QWgWDa5l1wsuVAM
	 4NOZkGnxNXKHpl1xAO7aUfZ2soQtTuSwUAmn8k3o=
Received: from [10.46.141.45] ([36.112.3.68])
	by newxmesmtplogicsvrszb51-1.qq.com (NewEsmtp) with SMTP
	id 3380C219; Tue, 28 Apr 2026 09:12:56 +0800
X-QQ-mid: xmsmtpt1777338776tlo703va3
Message-ID: <tencent_6B7B248CE4DD2C5B4471193F7B295ACC1F0A@qq.com>
X-QQ-XMAILINFO: OeGSc/E1+fkZieFR4/4fnYbmy1HnY6cKD5MsG73FjmptXN344R/7b9ihhpBgX8
	 BdQWw6ukUuKmJadJm/42i5R4V2iVWPS6PgwZHXXgo2/h7iZqEk/Px9KFotn8NjeqkmfAmT8MNUCL
	 RB5lIojFgQ4nQ/GbKhdc3HtThIE4uERTcD3uWXuiDugy65MAVNaCKPELqF2onG9kJbwZ4yFhB6xI
	 bN261YjvNuq85fnz0u+YnkOb0MmHXBpes8GlkTJr7CWYq+HnE7PVrNl7TSW6qWC5nu6nxB5pGhJv
	 cAq+fv5GaojZ3ANi/SX0n0h8bNKaf2gXOykjwbsF5JWTY8GxlPhrKobMOqUUhWJXi3YEmuM/tVRJ
	 3zkQOqt59wiJYLTpzZADq4sgOGykHichHbSaWtt/Qwm2GJv4poDvmAkq2vzzfhg03mbqt1k0cxZw
	 ezgbLXURMVBRqVS7dscMYNZANHdkhcfpiL38KWdxL7gAAx9cFCDloSVGoUblGgGyUv2pCAtSTk36
	 CS5nn+PJSYXQaktGsyfdCZHbWYEso/vx9vkP1xLiSWpclR1+gaG/XwVH6RuzXnZGjWiXHsSzkEh/
	 DXLf7vLPpbXGQpY/KvgXBZfTc7O5O+efeWaYzQxqj57a1SDmoIpfJRggYrXIdaTp5iJKgBH9fiqy
	 RtpdD7lUfDl6mso5e7+0eeF36v3XQBFOnWMy7Ar23pqu7geWIUr7wFTGIOoItR5VhNCbZNkt+Ut0
	 3HkMNVCBqISTbUOLh5firDmxNyw5kTPLVrjpTmecQ/SjP39o3XH0TwMFZpAYThdfTFUd/uiQe+ep
	 KXrzliejf3ZUpf07vKLphlKfZLYs0VPSo1s6/09HT5mQ9saEvE7tX8J5etIlxJj2nfPl+cOROD/H
	 FH5MF5ZRnTSTCjrRSg7IfgCS5CasIRpus3AhgZrfADNPceZnN+z+jOHbRbxd14GbaNDUBdWume5A
	 NGrzhI4NmEOQbf4Mez+wpTu+naWaiNqZ+8VqKx+i/lHt+uAGqqJZgyLt5zdghTtuW+dBijy5Aoiz
	 K8mCE/6Qq1GtzU48nDkcseidwGkYKwpB3MnDV/yVH3/MLDkL4scfH1CTljvaBVb5yLRWRQxvExu0
	 qyqPj0DMMi7ZEg7R8=
X-QQ-XMRINFO: Mp0Kj//9VHAxzExpfF+O8yhSrljjwrznVg==
X-OQ-MSGID: <0d3230ce-1609-44b8-80c4-2e325e9817e8@qq.com>
Date: Tue, 28 Apr 2026 09:12:56 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] mm/filemap: count only the faulting address as a
 mmap hit
To: Matthew Wilcox <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Roman Gushchin <roman.gushchin@linux.dev>,
 Haoran Zhu <zhr1502@sjtu.edu.cn>
References: <20260427165751.746502-1-fujunjie1@qq.com>
 <tencent_949F3B157FE71D3C7247AE6FAE2C5AB82809@qq.com>
 <ae-tkz6qe1zFmXVj@casper.infradead.org>
From: Fujunjie <fujunjie1@qq.com>
In-Reply-To: <ae-tkz6qe1zFmXVj@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: E267314000E
X-Rspamd-Server: rspam04
X-Stat-Signature: x7esfb33db5ioxouba1x6wp3z1d15xx8
X-HE-Tag: 1777338781-392143
X-HE-Meta: U2FsdGVkX1/+BPK4HfGMvUoQBCoyA9/4+L4V3K/WfJUBDYUrOwb5v6OYqiz8Xz+g+lz+HUpC2DYETL6PcOpjFAD5dnpChQFyIgc+94X1ijTZiWIiPUaZalfJR8CSdmYqVqGM3Sm5wYwDkgMHlN8FExfsw+3/CZhIX7GH1lzNlVkJDbOSBNY+9MCgSucvIyZd83J7ah2vxRwvVRrFNdmREMedqN1DKdcvUDQA54MF1pOOpj8L8H82i2lUee4WIQX1SFKjeL8guC25MLqGVJ2ej1JdZGiFY3lbfYvY1cm5fsCD8EJpIvFrndgxo1id+AYtpEuuC4Zgu1u/bSm4x6AAe4GI+DFrIuOHKPw2f9sq5LkbCoa4bJxAVKBp+2dUIHZbdDV7o/aKyu+R3VHov93HnRVlKJ4RIo0p3a3hZv7K+6LToDkbHrGMyyvNseEr2F3HsxYJsMQUqICH/M5olHMieQ8BD1nacSpifQp7Pe/j3AxelGf9gYvD8icFjebWnAATIyKo6zchPRO0v4hJeDKZrKva8ZPC6qN31Z5QSuGThSnH2aN9uLWJA/gs6ao2rEkEtdslyyFH3jU3gPZK8diInliLLowQ0SKy9g+8HdQ0+fkweWo+MVY1whvW95Ua+gkgTD5Mdvz94TgwWGzZFzJrLVEz3F+xKdwjjpJ3cnFtMYiYkYXYxvVXC3DfF4x1b1o3GdPI+Jd36feDkFS8viY5DqXkMtKwdVkXmlrPLHX0Z/LT4GsgSltHQ7v7cUR/0aO1qB8eDGyJ43/VWLiHYHJXnUrVH/jTE3g+a2cXZzKe8uDdf5qcd2Tuyo4moChF2NjOE1T4rWUHMrxf3jpjIKFQMlCG9sI8VEDng2u9q0AR/FnSJFlnvLvLje4tZZSqZNzAaKx9OYd8U9nujmcrj71BbOnl0IfgUG3U9HkWS9usBORd0lgh6Vt5VsAQo8T7zg2lKu/L9PRhhGYDOIqlGra
 wyDKu29I
 dWiR1NyaG0Dv4NlM9s/nky9+zzvEUV7wMR+nd5O5fV7y8Rs086SQtrQfEwZbfb4sAMLr7v+keFYLJIpkLgUuKqcCsV0dVnvUgV86v4Au6DcEyqfOOf27pjIleDc3wG9Zkh1lxdh7akLNnfODdWGZiXpGr/zkMo/+HjCLM9zBKSSiK1VvjpGpNFwePbISr5sk0oD0nk7Ld5pXTZpfE7sMxBQe2ZnpZY3/MM3uaOYVB/5Of5GD4sPEpZPjjIB7V35okbSdUzHTh0Ujcxtl/di+A4E1/m/D7w2Xk5r1DxPyLbe27gxYGCyvjhjKlivX494oLzGYPpuCJ1Gd7bSpyihn1HP0Dve0TMe240XuK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On Tue, Apr 28, 2026 at 02:40, Matthew Wilcox wrote:
> On Mon, Apr 27, 2026 at 04:57:50PM +0000, fujunjie wrote:
>> -		/*
>> -		 * If there are too many folios that are recently evicted
>> -		 * in a file, they will probably continue to be evicted.
>> -		 * In such situation, read-ahead is only a waste of IO.
>> -		 * Don't decrease mmap_miss in this scenario to make sure
>> -		 * we can stop read-ahead.
>> -		 */
> 
> I'm sad to lose this comment.  Why not move it to ...
> 
>> +		ret |= map_ret;
> 
> here?
> 
>> +		if ((map_ret & VM_FAULT_NOPAGE) &&
>> +		    !folio_test_workingset(folio)) {
>> +			unsigned short mmap_miss;
>> +
>> +			mmap_miss = READ_ONCE(file->f_ra.mmap_miss);
>> +			if (mmap_miss)
>> +				WRITE_ONCE(file->f_ra.mmap_miss,
>> +					   mmap_miss - 1);
>> +		}

Yes, that makes sense. I'll move the comment there in the next version.

Best regards,
fujunjie



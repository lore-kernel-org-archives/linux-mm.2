Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0AB5D41178
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 12:01:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27F146B008A; Thu, 15 Jan 2026 07:01:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22D026B008C; Thu, 15 Jan 2026 07:01:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 138DD6B0092; Thu, 15 Jan 2026 07:01:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0402E6B008A
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 07:01:55 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A869AB836A
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 12:01:54 +0000 (UTC)
X-FDA: 84334059348.28.0B6AB6D
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf22.hostedemail.com (Postfix) with ESMTP id EF4C4C0004
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 12:01:51 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	spf=pass (imf22.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768478512;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ud/J85QV+BEQ0bP0JtZ4ngTyr5lpqKGqcXK2k5Mpbe4=;
	b=jz0HWJPwp+qC2uNlv3FncnBRHV5zGZ/hiK/4ll6beRzYi6N1XvwWqzrvTG2DLOsUJdKhMX
	p8OQw8vjjE/TZehZvGneISh5LGgWAg6QNt0SsLx1KS5PWc/89X7sH4C/qJggV+iY0Cx2/a
	DWaKMsM9ZP4VQS2xNDnNRJlmWtgdzms=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768478512; a=rsa-sha256;
	cv=none;
	b=iqNsp+jr7cL3Pbkx0ClEVynv5EWv1yAFvIimfzCcuBi4xLdmJip0nf4mzNOykZXCBnIXYi
	4xLlpd8Sm+0f9JVDV/Xqv5BikUy43d8+fwWaHgxxDlYjxdg94If6zMq17UhC7uMc2ADQzX
	4Ii/seUFh4V/e9p/WuRJQyjhW+wVCxY=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8CEAD3368D;
	Thu, 15 Jan 2026 12:01:50 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 543513EA63;
	Thu, 15 Jan 2026 12:01:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id NDM1FC7XaGnnWwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 15 Jan 2026 12:01:50 +0000
Message-ID: <2c4c2b2e-bf96-4c4a-a66c-93b66553030c@suse.cz>
Date: Thu, 15 Jan 2026 13:01:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 23/23] MAINTAINERS: move memory balloon infrastructure
 to "MEMORY MANAGEMENT - BALLOON"
Content-Language: en-US
To: "David Hildenbrand (Red Hat)" <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org,
 Broadcom internal kernel review list
 <bcm-kernel-feedback-list@broadcom.com>, linux-doc@vger.kernel.org,
 virtualization@lists.linux.dev, Andrew Morton <akpm@linux-foundation.org>,
 Oscar Salvador <osalvador@suse.de>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jonathan Corbet <corbet@lwn.net>, Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>, Arnd Bergmann
 <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Jerrin Shaji George <jerrin.shaji-george@broadcom.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?=
 <eperezma@redhat.com>, Zi Yan <ziy@nvidia.com>
References: <20260115092015.3928975-1-david@kernel.org>
 <20260115092015.3928975-24-david@kernel.org>
 <f2ce1126-0059-481c-b54f-0b09518666d3@lucifer.local>
 <284775bd-767d-45f8-b66b-96709dabcc5e@kernel.org>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <284775bd-767d-45f8-b66b-96709dabcc5e@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: EF4C4C0004
X-Stat-Signature: ym5r8o8sidoipurqk73fupkcusrwh4mr
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768478511-163296
X-HE-Meta: U2FsdGVkX1+S4ynkvYtAQ6od0xm3/l13zcm4EkLrldC/Hj38YPnKaZ8/eRhpQ9MQLAUx+SdaY1esYfufjgGCAHyW8rvK4aPxzG8pwqwOC2FGBKH9c5+VoJ8ZX2vtXACwuYXphUriM6mqSPgbMsu6/fX9VgvWrTYXeu4IEtbJ1REs4+VW11Sdh54sH2Kzi+RGh+QJwRDRf58xPZH6D9YLn0LZKyfwIAk2lD715xYclK1qheBlUQ9EcF497Lc0NbnRulFg2gz5r0w3xmaDAafwR2Y1cHZhkO34M8oMF+tkq7Mx/bxd6cLaCDyDuue3G4vxIrUGrDR+VLgxnBKJYR/F0iiZfgRy1AzTIHdQDs/Ptna5x30SCacmO1npXKkOr7yb1Kww2plYl+TQHIMOqdYflZKOKbI+KCqI0EADu9aS9EPQ6K2HwFRQsYS9fPX/S8bZp3VCZr76bwbHBUHUEWSsyvwkL3LomZ66ePbHrJrN2C6/YDsza0cmysCOM1JHnbbCaCK2YCjRfgLb1ateFKBpu1WVllVpKTnDhWjF8ZKgYnQ4gzEZurlnt0Uxrz0W60XhwHQyAtN1cow9pPHiSueKs8V7giZrGWPozodTIy48RyXpSrl6I5akBjBZXBFU4S1+PGfbUMnyu8F8Aah9kR097r93v8BKAr1TC2BQlv1MZ1aC7aGR2u4Vjp9nbhQTn6bN8SLse516PKt+ZsR5iudtQ+cLx+i5Cwhc9MLsL6wqiz8pgOxls16PrbudigH1xteq2Hf2P6lYFk0Hmv+Xl0zjztHSb+VQZ9DqMzY6r5V0i3y38ub8rtjh1kA5NSdsbinRdewhdfIJJSW8PQJIOAQ0DQb7MvMqDXCXy0tnk6Up6eyboAOpuwnCkJpvkzOavNsS+Lzzp/4cRzdlFXkYl3At1W5GwiHDgx2YaZSCpbK9bv2oEQ7QyiQJ9kDLw/I18jWQpxgZgY5epGBN2+pnRk3
 c8nH4Yzv
 pjvYWR/XxGEQXs5AsynjPWbOdqgL4/i84L7iA9XTioCf0z38oD0OVbc+Cqf2Ee2gD5E1EKb6KatMG08lUo71b+fmBzt/gJbV09mMO6iNETNj0ZpUtvm6+pKxFna5mBSrIFN8UHVshx2gR174IVRwhxYBZwEat0H4zJ+oCtsvTdnox+/88YfQLt27emGa/PQYIw47xVN9/+533m6P5wEgedUkXXVTmGT941nrfsr7G8qgYS5EbNEmBc+1kRctsNhae6wcOTfdPz401b+xJ5xhPymTgO++d/y5GZszsjtsTe5dsg0mjj9b8SGUo9WZ+JysXU6LvQSZmERnJJskEta8z/XB4lUmZyLyQF0ZxVPtHJmNyjxA3iI7weFCrkw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/15/26 12:25, David Hildenbrand (Red Hat) wrote:
> On 1/15/26 10:39, Lorenzo Stoakes wrote:
>> On Thu, Jan 15, 2026 at 10:20:13AM +0100, David Hildenbrand (Red Hat) wrote:
>>> Nowadays, there is nothing virtio-balloon specific anymore about these
>>> files, the basic infrastructure is used by multiple memory balloon
>>> drivers.
>>>
>>> For now we'll route it through Andrew's tree, maybe in some future it
>>> makes sense to route this through a separate tree.
>>>
>>> Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
>> 
>> Assuming below fixed + Michael's concern addressed, LGTM so:
>> 
>> Acked-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>> 
>>> ---
>>>   MAINTAINERS | 12 ++++++++++--
>>>   1 file changed, 10 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/MAINTAINERS b/MAINTAINERS
>>> index de8f89ca1149f..b974f8c1c2225 100644
>>> --- a/MAINTAINERS
>>> +++ b/MAINTAINERS
>>> @@ -16454,6 +16454,16 @@ T:	quilt git://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new
>>>   F:	mm/
>>>   F:	tools/mm/
>>>
>>> +MEMORY MANAGEMENT - BALLOON
>>> +M:	Andrew Morton <akpm@linux-foundation.org>
>>> +M:	David Hildenbrand <david@redhat.com>
>> 
>> david@kernel.org you mean? ;)
> 
> Maybe I just want all the patches to go to /dev/null soon? ;)
> 
> The following on top:
> 
> 
>  From 3d344330b1ff6088582fe8e3bbff49d1557eba22 Mon Sep 17 00:00:00 2001
> From: "David Hildenbrand (Red Hat)" <david@kernel.org>
> Date: Thu, 15 Jan 2026 12:23:57 +0100
> Subject: [PATCH] fixup: MAINTAINERS: move memory balloon infrastructure to
>   "MEMORY MANAGEMENT - BALLOON"
> 
> CC the virt list and use the proper mail address.
> 
> Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>

Acked-by: Vlastimil Babka <vbabka@suse.cz>
for both

> ---
>   MAINTAINERS | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index b974f8c1c2225..11720728d92f2 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -16456,8 +16456,9 @@ F:	tools/mm/
>   
>   MEMORY MANAGEMENT - BALLOON
>   M:	Andrew Morton <akpm@linux-foundation.org>
> -M:	David Hildenbrand <david@redhat.com>
> +M:	David Hildenbrand <david@kernel.org>
>   L:	linux-mm@kvack.org
> +L:	virtualization@lists.linux.dev
>   S:	Maintained
>   W:	http://www.linux-mm.org
>   T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm



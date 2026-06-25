Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 706E5CDE002
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 09:11:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 633406B0096; Thu, 25 Jun 2026 05:11:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E3DB6B0099; Thu, 25 Jun 2026 05:11:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FA056B009B; Thu, 25 Jun 2026 05:11:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 27CD66B0096
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 05:11:11 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 96FA01A05FE
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 09:11:10 +0000 (UTC)
X-FDA: 84917865900.18.14DA363
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id CFD8C80006
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 09:11:08 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n0rd3Hq8;
	spf=pass (imf30.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782378668;
	b=t+bKaQdC/mhjf3Mihs9bH7rQgsvqUOQ6d9CFi/yYkKUIXZ4aiLKjDozOWGlQiXeuejoL/P
	cUfHlQL4DP8BNj8fdIGJuZk8DvJn3/qaBNCLq4zJM3r06cG4+cODWBNyjV/h81zNHg0to+
	bT1+ygTGMW7YavyWMmTjfV/43CEIVZg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782378668;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w/sutQTxrkpg6/YMIZU8opSDaoNh05pdMby8e5mXodQ=;
	b=uqZgb9/f4z4etZ1zpT9HhiSy4vs8eztUa/rRSCqM0IB5J7zPQl4A0hS2977GT6nhTYlck1
	uoPWL2JrVXkisdBeckLNRB3Y/7ploFsCR7WXLoVoqLfux4QhCt7WfzKk0yyZkwgZMVkjw8
	tQnDNkDk7y5cJq+erKvzBTTvq5UGtbw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n0rd3Hq8;
	spf=pass (imf30.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 61543600FF;
	Thu, 25 Jun 2026 09:11:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E79A11F000E9;
	Thu, 25 Jun 2026 09:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782378668;
	bh=w/sutQTxrkpg6/YMIZU8opSDaoNh05pdMby8e5mXodQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=n0rd3Hq8UXydvt8y0GFa1ngVOYAY3si0zXLn/WcE1kmSJidgdkN4Ztp+BDfqBHGus
	 iGbF/STWqCa8w6YsvBW740mJtwdt4fLL3dMxRvt17IHur3M0Xxpt9DuLx3eFEprzGW
	 ZcJ1mftxKRknK5TkTmjiR4rVC1S+JhbzEuQfc46XQtZ8pryFdQMt3t9EaNW71Uxw0b
	 WjNiF/ntKLtDjXbNakPN+1bqkG2k/Y9T+TdFLMtaCMsIzVqAOxh/4hA71BQjErW+Di
	 64THDw8NvDG72UgOu9GVIU6kfwKebCaZT0yPxgdkZfVhwyKIEAFQm//3XjmHN+4OPE
	 qoKR5Ymnu+4kg==
Message-ID: <fdcf9684-56cc-4389-a845-c53386171974@kernel.org>
Date: Thu, 25 Jun 2026 11:11:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Docs/mm: fix documentation warning for GFP parameter in
 kmalloc_obj, kmalloc_objs and kmalloc_flex
Content-Language: en-US
To: Andrew Morton <akpm@linux-foundation.org>,
 Jakov Novak <jakovnovak30@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 linux-kernel-mentees@lists.linux.dev, Shuah Khan <skhan@linuxfoundation.org>
References: <20260619113622.11712-1-jakovnovak30@gmail.com>
 <20260624184856.55fe055b85e17ed2c6572182@linux-foundation.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 xsFNBFZdmxYBEADsw/SiUSjB0dM+vSh95UkgcHjzEVBlby/Fg+g42O7LAEkCYXi/vvq31JTB
 KxRWDHX0R2tgpFDXHnzZcQywawu8eSq0LxzxFNYMvtB7sV1pxYwej2qx9B75qW2plBs+7+YB
 87tMFA+u+L4Z5xAzIimfLD5EKC56kJ1CsXlM8S/LHcmdD9Ctkn3trYDNnat0eoAcfPIP2OZ+
 9oe9IF/R28zmh0ifLXyJQQz5ofdj4bPf8ecEW0rhcqHfTD8k4yK0xxt3xW+6Exqp9n9bydiy
 tcSAw/TahjW6yrA+6JhSBv1v2tIm+itQc073zjSX8OFL51qQVzRFr7H2UQG33lw2QrvHRXqD
 Ot7ViKam7v0Ho9wEWiQOOZlHItOOXFphWb2yq3nzrKe45oWoSgkxKb97MVsQ+q2SYjJRBBH4
 8qKhphADYxkIP6yut/eaj9ImvRUZZRi0DTc8xfnvHGTjKbJzC2xpFcY0DQbZzuwsIZ8OPJCc
 LM4S7mT25NE5kUTG/TKQCk922vRdGVMoLA7dIQrgXnRXtyT61sg8PG4wcfOnuWf8577aXP1x
 6mzw3/jh3F+oSBHb/GcLC7mvWreJifUL2gEdssGfXhGWBo6zLS3qhgtwjay0Jl+kza1lo+Cv
 BB2T79D4WGdDuVa4eOrQ02TxqGN7G0Biz5ZLRSFzQSQwLn8fbwARAQABzSNWbGFzdGltaWwg
 QmFia2EgPHZiYWJrYUBrZXJuZWwub3JnPsLBsAQTAQoAWhYhBKlA1DSZLC6OmRA9UCJPp+fM
 gqZkBQJqFFy6GxSAAAAAAAQADm1hbnUyLDIuNSsxLjEyLDIsMgIbAwUJGtCBUAULCQgHAwUV
 CgkICwUWAgMBAAIeBQIXgAAKCRAiT6fnzIKmZJIUEADFx/tREzUImHrEwVHeSvDFmA7tJysI
 UVrlvrM09E7GIuzphzv7jYmo8n3ANpCczLEVr4G0syYQdTigaZgv3+FQDIIzhKih1IHhu1Ei
 XHlywNWKnQxxQEUNi5Mwx43wQz5XVw9F1A7gtKBKNtfogO511hAbrzagrYajyQacEJ/+sfhZ
 9Da8ltHIXD8pcYaHUfQgEusCgmEd9+KrUwrTbckFKmYq5chuE6yJ4J0EmWknL096jIE6CnzF
 FRslQ3B1UKDjxVsm1ZHfir5NeWszLkTvGFsddFaWTgh8UycESG6VQzKXjjewXu2pG7YQYRpj
 QKm1W5X2TkwWkXRBZTmfmbhxIUMh3+zf5wQ463rSmDN/8v81tdqBtAW6rH/kzg1GvkaTHXn0
 507yEHFzBksk2viAuIxxr7km8+/KARYLIdGtx30EG8cKzAUZOK6WqxtNCsXUJNrVE8CWrCaD
 icoNu7Fs1c5hmPHdSTnU48ce67449DdnO4neLSNhRiGlMHJgfJUmgrxu/hcYeOZ3haWmEQ2w
 uW1Mh01OHi8QZHCEyAbABrPs9GUgccc/4eYXX9hIgxfSkYzn8f+8NuIFPWl/0uTvjgqU29FQ
 SbzOLxHq9439Ox40G5mS5eZXRGxITYR+6TXvRGI6P/264jvflnr/pDGUttaikU+0W+1uxgKH
 cmYbEc7ATQRbGTU1AQgAn0H6UrFiWcovkh6EXVcl+SeqyO6JHOPm+e9Wu0Vw+VIUvXZVUVVQ
 La1PQDUi6j00ChlcR66g9/V0sPIcSutacPKfdKYOBvzd4rlhL8rfrdEsQw5ApZxrA8kYZVMh
 FmBRKAa6wos25moTlMKpCWzTH84+WO5+ziCTsTUZASAToz3RdunTD+vQcHj0GqNTPAHK63sf
 bAB2I0BslZkXkY1RLb/YhuA6E7JyEd2pilZOrIuBGl/5q2qSakgnAVFWFBR/DO27JuAksYnq
 +aH8vI0xGvwn75KqSk4UzAkDzWSmO4ZHuahKtQgZNsMYV+PGayRBX9b9zbldzopoLBdqHc4n
 jQARAQABwsF8BBgBCgAmAhsMFiEEqUDUNJksLo6ZED1QIk+n58yCpmQFAmfIHFQFCRYU6J8A
 CgkQIk+n58yCpmS2PA//bqN1LfcotmArgElsa+0EGZSQlYgK48pm8WAeTXTngudP9IJ4SuKY
 HR5RNjHcBeqN+Me0zxRqYzRb8nGanHEkDyf4Im8DQM8d6vbyU+FcPmG4skud4kgS1zMHnlVd
 SXfSIwKC/hKgdHG8aBV7545Lz9X6Iohea+94wneD0aw/hqF+QWewGZhWJriWAZtvEkzNjQOi
 4U9F/trLten/x7bpphDSnDMKJtITbtzATT1Dq7o7VpIUK1nCTQALMuMjKCdi8OdU/+V+R3O4
 0PXWvX8qrvqYapVbZ+9KqT74FsuB0Ya9uXwgBF2Q6cRuETZk5vqaqKxzqoQZCO8AOz/58j6O
 2RHNy/mZEN+7tJ5Tsq42zVJ4jxsT8b9YplavCMsnBgDeRWhcbYhCyttoL7nYISyWg4kQYZ/P
 wIV3OuNv2f8iKYsxNsRuClOAF82+gvqOy1/1pprFjy8uo2pkoOrb63aOP3vO5VHnRKgra6dq
 NcaZ+c6J4H+nEJGi2SkHAUJz5oBzuThvPudLvPA/SK8sKoM01IRxSihev/S/5WLazXB1PGem
 OCbvzC1IjWJJraxiDJ5IygokapUa2RP7+WBR22skQ3SSl6G107QgWKSyTOGWEaRmV53vxQLV
 jXuCmzSSasTL60zq5yGrT4/DYQVSNEUiUbG4pYekxJujNeEDkUlky0Y=
In-Reply-To: <20260624184856.55fe055b85e17ed2c6572182@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ua917hh3izt5csp73bx7fokzj7odmtqr
X-Rspamd-Queue-Id: CFD8C80006
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782378668-547351
X-HE-Meta: U2FsdGVkX1/tzjIDVgjqn7lAVqFvaQvfsPDPMc4iCyXFiV0RFJAHT27NXTXlkeI22WZzpdkdvxB/cbT5yafuhTz6RUzqo7FWQxfz26N0BThBEfzFmCHZK2DJ8xzV/H6We3Zm7aOjyohkYoXwvACtuaTgggQ4N2bhlQ+xFL3kHcTEVUagZAGBn8oPyJa34grv5u8oWJJycNZWmfmzQeLB3/ivNGf/Ami96XaMtyqSs2d+J5rVTqlNdUW3KEqvMo3SGZmN9OvBTJEuUjqIbZsKEBmBBVAgVPW+VN4lU0IH0fkmrHPJa24tsjrXx7kg04U3I1glVQlgMk7m6YZcHpjmotlO5l1uO7fGNz/hfbKhPibK/ZIoM3K7g6nz16cnqI2mM9K9dm4V1ej+Z8egKFx3gopPkzePP9Dl0OC6d6UPTIRxM6qcqz6Lb6hx74LlYSzoDAvJPi2AylrO2L3EKB8nnddtJN+xJ4H7zSaBLniRaB6QhLGR7GAYm8CeopWwvk4tqJAOXELg4s48YGVN1+CFCpBpmBXNNrREaKGYDQ/+PAm52DVE8Lqn8yHahrG+JlnOuuTm1i+eRxBaXLr7VnPrS8O3VZfITPB9/0TFS+WY8bdjNh8fQvCwHOL1clt7gJFc8HwVCQNEdYCQWRYZpNmBZ4mwsZXCq6D6oM4tRypMwjj3KxTNj4jieqWS77AYjlPNFwDTeLX4jS4RJI2YJDpTl4LtQ5vHRJ6Sb/gpACAzQUaoWqqZowopg1GEyMUCm1KgLyNwfvxhKgW1yenxmvAJXEnk4hQcL0Cjm/oGF8OhUdamTjFvStOBvxXSoYJePXtZouQ3NEAXJGnNGreBQOFLrghmvP+X9XYDGSaK18qsnfTPMnw4P3UpVGQzCIHLXdw9wE6iEi6YCk48ApMBBfojNYzuxDy/q8ntm+x/bygtVCpRYsWZY7aw4qpNAqKwk7H48X+SuJBn0dG4LNa5XqT
 nXwVEz/N
 t0glTzMfeocZr65oWY6XRMwz59kj5hVaIwudPzqI16cev4Iwx7+GL7HqZJvefzJUoH3Nx2mlXourn0IwhTqGRE1J9vM9msT3Y78JTPLVwA+jmveaLzAxxwLshnEkqVOiD/hFcK8QEVOwrUTuGsmuxb9f30qVhjx9u36GrCZ/eZHKJYCmrIfIe/FcDOWT5s6jDgVezcl+Rtm9+HSJ8b+UsRs/B8uoiQtwvjUd8GLiX3D/plCjsA4771qgf06qstjfDcoRcOyuXIcqnQUnx6ojT5eTGGmObxRqq1X44DMp/hvmqCCksBzZQjBbZAcuSLlpwHQbEje5HBO1xH44=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/25/26 03:48, Andrew Morton wrote:
> On Fri, 19 Jun 2026 13:36:22 +0200 Jakov Novak <jakovnovak30@gmail.com> wrote:
> 
>> Subject: [PATCH] Docs/mm: fix documentation warning for GFP parameter in kmalloc_obj, kmalloc_objs and kmalloc_flex
> 
> Thanks.
> 
> "mm/slab: ..." would be a better subject.
> 
>> Date: Fri, 19 Jun 2026 13:36:22 +0200
>> X-Mailer: git-send-email 2.54.0
>> 
>> Compiling the documentation currently gives the errors:
>> 
>> WARNING: ./include/linux/slab.h:1100 Excess function parameter 'GFP' description in 'kmalloc_obj'
>> WARNING: ./include/linux/slab.h:1112 Excess function parameter 'GFP' description in 'kmalloc_objs'
>> WARNING: ./include/linux/slab.h:1127 Excess function parameter 'GFP' description in 'kmalloc_flex'
>> WARNING: ./include/linux/slab.h:1100 Excess function parameter 'GFP' description in 'kmalloc_obj'
>> WARNING: ./include/linux/slab.h:1112 Excess function parameter 'GFP' description in 'kmalloc_objs'
>> WARNING: ./include/linux/slab.h:1127 Excess function parameter 'GFP' description in 'kmalloc_flex'
>> 
>> This effectively omits the GFP parameter from the current kernel
>> documentation. This patch marks the "..." parameter with the previous
>> description of the GFP parameter along with an "optional" tag in
>> parantheses.
> 
> "parentheses".
> 
> I'll assume that Vlastimil will be processing this patch.

As Harry pointed out, Randy already fixed this, since then it's in mainline.


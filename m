Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6071CAC5B8
	for <linux-mm@archiver.kernel.org>; Mon,  6 Oct 2025 13:53:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD4888E0009; Mon,  6 Oct 2025 09:53:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BABDB8E0002; Mon,  6 Oct 2025 09:53:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9AB48E0009; Mon,  6 Oct 2025 09:53:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 945218E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 09:53:55 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3945459D3C
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 13:53:55 +0000 (UTC)
X-FDA: 83967832830.01.D4351AC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id CE58C4000C
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 13:53:52 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=c95OTyAd;
	spf=pass (imf07.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759758833;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CGLl7ctOpTpoDpfWPZR3DaFESuMtpId6EeCDbxcp3bo=;
	b=LYPTxQlv2Y1pBszomJQKfiegTKjFdIGtl0k+im0ILvgGMNSJ1EmL7mxiFqpPrhHa/Ae1Pl
	zdXyuy+1XmX+GUmhMSD7f/tI6NpFUfLaWTw2zrU6I7Ix9QTNHKpZjQ3HwUbLbTNlvng6bw
	j17kpxAmDXi542OWXi9fM6aYpw2SW90=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=c95OTyAd;
	spf=pass (imf07.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759758833; a=rsa-sha256;
	cv=none;
	b=8laX+opNsPNiaqPIG3eySdQdY3aQgLaBefzGPYel/vd0ahPC2MVG0l/kJ91vBOCd0XiKd2
	CTFF7FPlipIgKW0CQ0BYZHVoCynuYgI/ofMh/zBQDvHAdoFi6C8VafajZiSuNskSgkxxO/
	3RnFpDkR5MKQtb3Hdj0gLWszg+OhVPY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759758832;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=CGLl7ctOpTpoDpfWPZR3DaFESuMtpId6EeCDbxcp3bo=;
	b=c95OTyAdTyKLW9mGELgTCZizZ8Fwo8ORNBontJgvsNdQsLQUZbvhz4DUSzlQnKs/Se+zbm
	AP/+qu3fN6xfOgBbdUbSVQUds+/CYKrrIAp5+Og9A3m1e1xxqq5dOTH6RUplixE0DQf60p
	CZxPPQdtWa6/uY7OThbkqJPhZ8gjpnM=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-211-GqhjIBjhPc2Hf22-4dBlMQ-1; Mon, 06 Oct 2025 09:53:51 -0400
X-MC-Unique: GqhjIBjhPc2Hf22-4dBlMQ-1
X-Mimecast-MFC-AGG-ID: GqhjIBjhPc2Hf22-4dBlMQ_1759758830
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3f4fbdf144dso2680929f8f.2
        for <linux-mm@kvack.org>; Mon, 06 Oct 2025 06:53:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759758829; x=1760363629;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CGLl7ctOpTpoDpfWPZR3DaFESuMtpId6EeCDbxcp3bo=;
        b=jP3br2Cc1n8ivBzYjZmJiLn19FtyebS/yaE7NBa5gqEMMY4UcIPq07guMExcVcgM/H
         KDKfTihtTppEqO1Y3xGGc/T4rgto+3DmGi9qLuTe27LE63NllltFQYxw1ll9w8KyfLvg
         V+dT3Q5ocuwLiy1j9dospFT0OWQFfp0pPYee+3pmvQvuGYuLrwFFw3BG0te2xPBZXUJb
         W2Tx0ZmdwyoVwSazQCJAP43or04FtzAdIuqwX1ydkDmnw3fwN7ghtWNNLrLL1/K2O/na
         Oh5AdDZzytPgh7YSTbBP8eOVCyFW99LMWJxLMG5NRwtGopZ6baDJk30i1PSsif+WuImz
         wbig==
X-Gm-Message-State: AOJu0Yw6pN+ByjvdiyjJNY132aErIc9+sxPcp5YT9zzyHJulQ32nLdk/
	iJwKOWwiFcog0p4/UdXpKBbv1nQZfSqR0ob2mddpE0iKTZVjAc2TWEAHc11sAw/zFtgm4cVAMFT
	eLjatYWGPvxybhCHm3fgjtRTpNOFcu4dz2rd6PRutQIoNhz77bE1e
X-Gm-Gg: ASbGncvk+Rq7QI6Wxy0GflewuGnk2KsAMf+fns9zy8qVChy52VgXRAPOkth+CFTWfAa
	xKKFJKd4to73vK+q/2kTQ97tCXxd9iO/VrfJepVndyr3OG9HC/OsX2xnC3ilMxkXYIXSuoEatFP
	9KvC99FOorM3Ya2X8Bs7TYuvYySgVK9zCy7OyRlRQ8pDigD2AK/PO90E5LQDiPx/MpN5AfA3usO
	iiigSvrYtTfleiPbnDr4pEQJC+/AIjjbpLWEhv7cVSR1auWg+FdZ3FNaoepHB54aS0qxEkBNQ0Y
	ixX4DXj11iC7kr9NjiYPgd/C9hwiE1Nkt2DA4ePC6XKL8RnEryIssH6dFXYUirHXPMedjvc4BzI
	FsPYmLZiT
X-Received: by 2002:a5d:5885:0:b0:3cd:edee:c7f1 with SMTP id ffacd0b85a97d-425671aa965mr9519901f8f.56.1759758829616;
        Mon, 06 Oct 2025 06:53:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG4z3VUwSp6NiPOhxjtLfmmF5LdjV37JJ4DT2V+xwJ/f0irliRMICXktxy6TvXFLIvLoD96wQ==
X-Received: by 2002:a5d:5885:0:b0:3cd:edee:c7f1 with SMTP id ffacd0b85a97d-425671aa965mr9519876f8f.56.1759758829047;
        Mon, 06 Oct 2025 06:53:49 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-110.customers.d1-online.com. [80.187.83.110])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4255d8e980dsm22658378f8f.36.2025.10.06.06.53.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Oct 2025 06:53:48 -0700 (PDT)
Message-ID: <989c49fc-1f6f-4674-96e7-9f987ec490db@redhat.com>
Date: Mon, 6 Oct 2025 15:53:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] fsnotify: Pass correct offset to fsnotify_mmap_perm()
To: Ryan Roberts <ryan.roberts@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Amir Goldstein <amir73il@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20251003155238.2147410-1-ryan.roberts@arm.com>
 <edc832b4-5f4c-4f26-a306-954d65ec2e85@redhat.com>
 <66251c3e-4970-4cac-a1fc-46749d2a727a@arm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <66251c3e-4970-4cac-a1fc-46749d2a727a@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: cEeO9PIoESww6oOmZHa11zFEgDV3e_mbQvLRJW01zk0_1759758830
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 5kzss5yesb355niezn1km9topgu757c6
X-Rspamd-Queue-Id: CE58C4000C
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1759758832-948796
X-HE-Meta: U2FsdGVkX1+7NBopX82bLiyScww/dW442TKGXPN1QvtXc7mBzb+sr88uGNJ4pkKVQOfdQQvc3gveetIp+oUD9CEwy8WsVi/5pLaTkNobRfjZ3ZuizPh1Nr+TVRpvAvpGBYPBWY9c5v1VEVDYpGt2Oa2X4uXabvFu02t4pwVgIrisNrHJgm7ddd29cuc1ApV+B7hYQ31gSZQzYE3kqzd2umI62gZG47GZ+i3yXUeVPhilIg+y1BIS2y/SE2QaCuHoBF4Xx/qol/6irB0b9SoXv/0xepMuxw8baq0DTFvuRwd+1gWE6rrbtGWQfNYCr3F81oCmIlkM99VXHeoM940aj+u4J4UGK0qXrxwLy7jR5ImOI+Nr4MRT0/GNp0NuuO8MmMjCvNaktf9yzJNpSd2+Inp7FyiO6SUB91CKLPP9R4A198FugZ9LmNhrApxVkPp3qV0E7WG1cQ/Ojlh2sZXBaplRFwQN6iDesSvQLOZQToSulpLosxAJUi3zPsKoby1HBpgUAQjeeu+nCyGhbChiXr+Hz6yxIceVqTC8KTa8zaGMdafdHbFlFGb7AG2KrTyQYqPL9NzKoktXFMTYSyU9TMrPJ/pymp1zQvEvvHM3QraP65iW8bkwStCz9ijobvkfiA250C5BmJicDkFN2i/DmeZKAhipRVt21SelS8bUqZET9gvAF9iCoCwqIllzz+5O7V1Qbzk9Zb1e2v9VOajmrTrrmaagrr+sUvYRYyDoRx1E2Kzc0BB9KPBv474NPCoHl6xjRYntjHPYbRYl8HKzZhBnse5nyMs97tJf+36kDHMc+a0ak9wDfRzj0l50kXasYcH2e5FCsTvLiIOBErpdqwzYF6bJ7S8T5o+IR7x8IWdfiTjPCrv15Z7C1n+2KGjIr/GtVGnCaFEJmfUTONvk5njUa0GSbrZU85qe/duQhcibSkbuvougfFCOr56Cx4pXEJYh0WI+JHRL+LOhlvS
 W1iACvoO
 wiVK1+LL4Ut3QuVtDdd6+h22kEZXChaokQpfghgrkDPrqHrwbNAeKyUu+cv3f0bzI57IC088Cn/OugNmeia4mFxfFnCvlE3HUYQDNJ7ZZXAxm7TUk7UaL2MCgqS55Va5fa+d6LmvBe/w+u3KcNNCyx/IFe+MPs+Ma6U+hxYaSmFpQq06YxmYANjrYkvJ3TZL/V0G8ecH43SrQErldE4ktMFby9oy2IwpDyzbjp/B13XyOmttWtTkj5pelafmoU61PujQ9gI39SqU1JqgKcI3EprwR4Wabg37irQM7QuMZvfDlFIQLaPx8ev0JHlf840xV9oL6+SNAQmeRiFtE5/uPMtC/9ZOwWH5ECf5fSwYboDiIUaX0SKpnjWqz4369KddMKPMleKVeCjj8Q9d8uTi65xHw4x4Ep4da6JAKaM5tKm7I1TdrbocqFg8T/kMoYFLhT6vPmeT+6i6SQ/MG/3lL0hLznBb+0wAux5+u83ygF19/QYAIuPPrxOFIxq0mqil0a3xSMJHVSLXSwwtDmfP7G2KQZtWOLAKGBAWTVVJpt6vlJyxRzI6N/1dVdDYXIziJxb8U4XKroD5DOKWSs13BaLKuErqyP17/ds/V20U8ljQcIkgGU0DRJDp/7oZgS61XN5nt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 06.10.25 14:14, Ryan Roberts wrote:
> On 06/10/2025 12:36, David Hildenbrand wrote:
>> On 03.10.25 17:52, Ryan Roberts wrote:
>>> fsnotify_mmap_perm() requires a byte offset for the file about to be
>>> mmap'ed. But it is called from vm_mmap_pgoff(), which has a page offset.
>>> Previously the conversion was done incorrectly so let's fix it, being
>>> careful not to overflow on 32-bit platforms.
>>>
>>> Discovered during code review.
>>>
>>> Cc: <stable@vger.kernel.org>
>>> Fixes: 066e053fe208 ("fsnotify: add pre-content hooks on mmap()")
>>> Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
>>> ---
>>> Applies against today's mm-unstable (aa05a436eca8).
>>>
>>
>> Curious: is there some easy way to write a reproducer? Did you look into that?
> 
> I didn't; this was just a drive-by discovery.
> 
> It looks like there are some fanotify tests in the filesystems selftests; I
> guess they could be extended to add a regression test?
> 
> But FWIW, I think the kernel is just passing the ofset/length info off to user
> space and isn't acting on it itself. So there is no kernel vulnerability here.

Right, I'm rather wondering if this could have been caught earlier and 
how we could have caught it earlier :)

-- 
Cheers

David / dhildenb



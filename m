Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 305B6C87FCE
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 11:31:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE0866B0088; Fri, 25 Jul 2025 07:31:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB61F6B008A; Fri, 25 Jul 2025 07:31:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CC2D6B008C; Fri, 25 Jul 2025 07:31:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8F2866B0088
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 07:31:30 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 39EB71DBA76
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 11:31:30 +0000 (UTC)
X-FDA: 83702571540.10.BA70F5A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id B63AD1C000C
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 11:31:27 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dQRcFinp;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf18.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753443087; a=rsa-sha256;
	cv=none;
	b=b6CPvC/aIT8gdc1DjrO+79MTTWxuBaXNHkihNUwJfiAYV5aXheWvsWxKKPIjNAre+FD31K
	77z08aZGPTUOPk5JCbV18sE6vSjB70eq/MEexzuXLPV+8S51zdwn5/OEmcQj4YOuGj2qcP
	Mtmd3D0Sz5Ps7laqVFHw0zA2RDr+RhU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dQRcFinp;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf18.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753443087;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BmxXs6pJBA2fg3s6c32iEeTNLDDw2KZ9iEJnk+P5By0=;
	b=Jto9U57hqgbYiGjBhEFfDE28VbQazET4e486zpXHhWKml6b9fzdxYPf58XUE6thTvYdeqA
	wZCLBig5z3tsDoZhRsAOrHPWT9wArhYzqNWUbgf7QMIvUQ9aQ7WQPsQ098HWTQxjOGSt9Q
	livDkMUoJfFkWCYthDHd7lLx+ALU5eE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753443087;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=BmxXs6pJBA2fg3s6c32iEeTNLDDw2KZ9iEJnk+P5By0=;
	b=dQRcFinpVgga5eL5KAp+ex9dZV7vzRwx0cOKDFf0di55D9/1YV9FRKhxtpzh0E2WFAOnRb
	ny/JZvkLJTXAmONj+ckp2eSh19ESOTMk4Tw3XFZV8c9osLO3PG5X7TPIuHGACCYpjG829O
	toxqHh2VyD2X/vsI1ABbc5yeqeg6P/8=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-332-AgDyDlYFPpaac3y4qdFWLA-1; Fri, 25 Jul 2025 07:31:25 -0400
X-MC-Unique: AgDyDlYFPpaac3y4qdFWLA-1
X-Mimecast-MFC-AGG-ID: AgDyDlYFPpaac3y4qdFWLA_1753443085
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45600d19a2aso15523995e9.1
        for <linux-mm@kvack.org>; Fri, 25 Jul 2025 04:31:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753443084; x=1754047884;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=BmxXs6pJBA2fg3s6c32iEeTNLDDw2KZ9iEJnk+P5By0=;
        b=J4YH09vdhDQLTjWrxa+r8yd+bRevehCWROIsdwgkcq1Jz07lWs0Fh+XgGpiHwGCcZ9
         gi0lfWWH9WJKYTwEa5G/oxFjvJmhcyJ/EpBJ7zqrE1plgp6cF4QGLD2fm4M8O6VivzlG
         k+7t6w85DdoRhmzbUxuTimd2spbqMSPyKjE5+Mhw5i9oN78ohTPuSLDcN2rAIh/eCb+/
         Uz4fC8W/6GsJjun1fTYokdXSy9nKj1lVBET8EOOCirWmijil88ZMEIFu5urXlGpsKQa6
         Nblq8vEOtzcVkdr0LxVPSZCAK2M1BA7krWj/cWNlX/cGlljdWlqT++VxbomNVaNo9tXG
         mccA==
X-Forwarded-Encrypted: i=1; AJvYcCWPNZP6b3pdI0iyfKyRCovmj6AcBnneoreGOkTx3sWPrbp2lKLbSSwRciISLfnOTMWyfESX+R7DMQ==@kvack.org
X-Gm-Message-State: AOJu0Ywto8YLpdeFxQ3/s5t8/Wn9fja1dQ6moJ0wqvOcsV8dq6xd4c+C
	S9IlLKkicaKCARTZuWhedRjCtt/y77FnpZZSGnIxswcDlaUIdumg/ExkqTzVnjwjBBU7bfNNE7T
	XO3ld1cRjKmxEwEnPX5y8EJr6CsjRM03HFXDeaUlBKx6GuGgTli3i
X-Gm-Gg: ASbGnctW9bLrioA8H+f3L73HMeYnCX7QX5MSnf3zLqv4PwuopExjH2h+X65kffTyNVy
	legyeIuvEwwE1L4+SldbV/xvvYYc45Q/48CAfgL6ESizwsVuVNuY2f2fmGsLbxXCxEgBCMhUOr1
	CyQsKY+NgyiOC/ABUZBs8WPrFwqVwjXhsZIwTfth+3BaMJonbIRiFDKLeLFZNCyZig3WzbN0zeK
	zA3e5hSqEGL0pRD+O4rr99P/TROzdOF9QBuIe82X8WPzEVZoQTP5Jkugjs/m8Qw8aAVqqiwbsf7
	ARWCHQcRe2/v4ajklkVjw1C17jOuufZlJShNWRNkNF1Q+vI1Qo7fshoYDTD/8etUMlaye2Hbu9M
	30xBQaDQ6VJs5ujYJ2RcdbqKcd5KxRZuYiGCeo1xLuyLTASv/4PxGxvd7pDvvYH1oaS4=
X-Received: by 2002:a05:600c:3486:b0:43c:eeee:b713 with SMTP id 5b1f17b1804b1-458765457c7mr14180405e9.20.1753443084587;
        Fri, 25 Jul 2025 04:31:24 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGyDRVNwUhQZmInqK+trerIAkKwiA6XE4MdEY23cCvQBgdpasZQjVKWm6WOHJPMGTNDt11OAg==
X-Received: by 2002:a05:600c:3486:b0:43c:eeee:b713 with SMTP id 5b1f17b1804b1-458765457c7mr14180025e9.20.1753443084112;
        Fri, 25 Jul 2025 04:31:24 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f1a:f400:5a9f:b1bf:4bb3:99b1? (p200300d82f1af4005a9fb1bf4bb399b1.dip0.t-ipconnect.de. [2003:d8:2f1a:f400:5a9f:b1bf:4bb3:99b1])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45870564ddbsm50462835e9.22.2025.07.25.04.31.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Jul 2025 04:31:23 -0700 (PDT)
Message-ID: <d6781e05-bde6-490c-af79-97993ed9018e@redhat.com>
Date: Fri, 25 Jul 2025 13:31:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/rmap: Add anon_vma lifetime debug check
To: Jann Horn <jannh@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Rik van Riel
 <riel@surriel.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Harry Yoo <harry.yoo@oracle.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20250724-anonvma-uaf-debug-v1-1-29989ddc4e2a@google.com>
 <85c4a092-14df-4478-811c-f3789610e4b8@redhat.com>
 <CAG48ez1O+7ciCNDVnh9MPh_1_1TLWd-=H9L6p90J_9AEbav27w@mail.gmail.com>
 <bf29d398-5f7b-449c-b142-cf9873a5b183@redhat.com>
 <CAG48ez1=rd5W5SBAyyqu-=50AsRGg8pdYW5BZ4SFhHqFYOHbyg@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <CAG48ez1=rd5W5SBAyyqu-=50AsRGg8pdYW5BZ4SFhHqFYOHbyg@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: g-xNY1Sojn_YcDXH5qlTc-13cqciadbuJ4Ye7J0weuc_1753443085
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B63AD1C000C
X-Stat-Signature: qehyjzmi6yp5s4x9tysf1k4e7fmknzod
X-Rspam-User: 
X-HE-Tag: 1753443087-719467
X-HE-Meta: U2FsdGVkX19dvUrQfhOV67edh+xQ/2qHHp2DYdEeoeB+4q4S3BtI9LVL0rIoG/k9mpAZ8/CxOEhPKG5LG/qvhwe+foHJab8whrdF8GzMYdKu1PU0tjDlZlTZRAzkHrxvEZyl9uCO5fkLEv5a94hKq8wLYhq5j5e2A1M5dwaQeOxSeqoKiIOttYuQZ8BcAZvEHfVpdov2snh8PsI3WOMJnfW7Q/8daQL+/ypk2T2NxPaFE54hxPRdoCXysZXESSQYc9hgLt1Z/AXaY9YRp9gGQ/oMIyvbANX6GQX9xVA844LD7r0wkrvPpNf/8L8G/Yb3k995lIyTk7nhv1IRTDGJdDAGDPvPMzD44ewuy9XrQGLFuD7RYx0A2qLR4yriKU0jsmlUpWbzXbpX0SKRWtUK0KLxDBWWbC1+KxLVraMWQAKXCmmqYiyl04OurV3wsbGzdMF21KxVOXdk5/2azpWIjZ5x7dX2r67FHA7jKmxQFWeeEwkcH69CjB7swoRmiqV/nVgqzfXNkg6SAJ8gC/kvWB9FJ7KyvT+6zqzGatqtGhkSBMonn7hckIhxOLBnXScGV7cZ+Xr+jIvsWR462j21nSWzuUscmNm9mgiPK9U8Ct5lvgMjJ6agklD6wxuurdu90fH69oh6D4BcHl2UUFJkNtTSaKB+XRxEYo5BQER7qY+C9OMPb/3u6Hg05lxqnw5xk16GGP9fcX0tUEvIAAHb/AWRg8OIBhGmdO2LNFenyHqdX5IofVO5SvnOYH0numxg4Y5rEdt8WR6XIJ0QLY9kkakzrM2G2uLTGYyGdUFHcRmm50XjeVyE0xje0Cuf8eB+DH8g2QitXT2jeSp5UCqq14E0h2sgR/AeMQLA9a08aziI58X64YbtLtcJ9eEhciBwoq52YtwShNqWP63P7SsuE+/14qp07yIV2HQ1vAhBJdmSxjgx3emln+R0KhVpdz5VGcDqCoFp3dh+oXUbv20
 /ACrzGNl
 oCOtxuD0fCZSugKh5876ftM1t6Mc0UXPHxtoFB68Sh1ylREOOf8rJkagJYrwRSjT/H+P7np2FqKhfjsZ09MZKpc/jCzAEQgk+hdwo15KRQRRT7BmWhLcwDYXUzLqLxfuC3bGQBOJSAa/vh7krH1wGqN37O5hyAxFUagjTUClCNpqCvXZR446uqleLbX6adjCaPne5SPRodf2irh8i7VqtUoeqceng2QEEFGQtPiXwv23Y+FM2Ff95k3FZRDpbU4DdxcpICgayO1AHEi1iWE+/XQ9EGU++yUc7PddiaXruL2ZajJQAwlrza0NJ+Qll5urBd9IaN+FaBAlnjVCktV4/eX4mWZu3BV5mWLF7HUFZDR1B0vqSZKJv1MZegjrHFcMAepZymdZQ800YVks2Me1ACrKvFoWc0tK8BzagQ+9VCUbFBGMkrC29FORrw/YmrA9DuUgDPqN6UB8Y1/lIhz3OYGJZmGIlRyN6O4fba50zwhQ9taQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 25.07.25 13:24, Jann Horn wrote:
> On Fri, Jul 25, 2025 at 1:12 PM David Hildenbrand <david@redhat.com> wrote:
>> On 25.07.25 13:08, Jann Horn wrote:
>>> On Thu, Jul 24, 2025 at 11:56 PM David Hildenbrand <david@redhat.com> wrote:
>>>> 2) We have a folio here, so ... better
>>>>
>>>> if (folio_test_anon(folio) && !folio_test_ksm(folio)) {
>>>>           ...
>>>> }
>>>
>>> Hrm, okay. It kind of irks me to write it as two checks when really I
>>> want to ask "is it this one specific type", but yeah, will change it.
>>
>> Well, ksm is a subtype of anon.
> 
> I mean... not really? At least ksm folios are not a subtype of normal
> anon folios. 

Well, what I mean is:

A KSM folio is considered an anon folio.

An anon folio is not necessarily a KSM folio.

Of course, there are implementation differences when it comes to 
folio->mapping etc, just the way the rmap works.

-- 
Cheers,

David / dhildenb



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A76CC83F27
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 19:53:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC20F8E0001; Tue, 22 Jul 2025 15:53:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B92F66B009B; Tue, 22 Jul 2025 15:53:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA8E68E0001; Tue, 22 Jul 2025 15:53:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9D6AA6B0099
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 15:53:19 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 30CD35930F
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 19:53:19 +0000 (UTC)
X-FDA: 83692949718.16.B6134D3
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id DB73A14000C
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 19:53:16 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YCWJjsGh;
	spf=pass (imf09.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753213996;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TdWjMJJ2t2kjmQGDaZjJdxIytGVnbPWFviDNWJnQ46o=;
	b=WLWYIRDbu3U/TIGWg5Ct7Jc0CNUbckBCTQeyG2ICpNcjb7fzqwLYXyQRjvWJU389RBMVob
	Xsw7Z2CAJclmAGsEXb5yd2zJJdOEh98Q0O7tAJ0VGjjixbZ4IeJej9ia7slSjdkGk5v3qu
	oMW7JRQvuN+OtIUlYY3bPkhzTwGa2JQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YCWJjsGh;
	spf=pass (imf09.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753213996; a=rsa-sha256;
	cv=none;
	b=tIJ7iEW7bIv91TkSx4Ro5VO4WL99F4m5fdh/Lt8uBboJIsgwKH5Ehbb9tCXRiWOSW5Wa+b
	vnTU2QeEfcuKtnGnhpulp5Xe4J/Vio4EGVd8/po5/KnTisxL4FfuONNRtOLGV2e0wY43hU
	xvApE/G5FDY5LiDAFTX0ocFzv1suqv4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753213996;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=TdWjMJJ2t2kjmQGDaZjJdxIytGVnbPWFviDNWJnQ46o=;
	b=YCWJjsGh4Duwlvt5wWwcVUzhvNheuRylsaNZ3eCXCvcSO8DkcT610YIjWGwUF2PQsr7tZo
	ewyY9KT5Kpvx71KXMlncTxpIJ1s5Ercg1qlvfWMHziaZ0INrSZTWpAKtIIOMHcYjHR+wNg
	ktSTisTzJecR1MpYvwjPcbBuBDW2Zqg=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-629-fQ9bIRNAP9GnWXlkcCaVoQ-1; Tue, 22 Jul 2025 15:53:10 -0400
X-MC-Unique: fQ9bIRNAP9GnWXlkcCaVoQ-1
X-Mimecast-MFC-AGG-ID: fQ9bIRNAP9GnWXlkcCaVoQ_1753213990
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-455e918d690so1111575e9.1
        for <linux-mm@kvack.org>; Tue, 22 Jul 2025 12:53:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753213990; x=1753818790;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=TdWjMJJ2t2kjmQGDaZjJdxIytGVnbPWFviDNWJnQ46o=;
        b=VC1MbQql+3y6gineMTTQ8g74rJ57QCKuzOvOO2JmQb4GrCgWt2paliwJvX9/Qc/sys
         owjeFQ/X4GPSSQmzGgxNWPV+e9qFDb2FcQF/5y9jLVd7ReiZLrT7049f0lByBNc3y227
         PpzxuN4HJOwki3kvPOCLg39zk1YTNuXvrQWaJzYv54OGTkf4fEmQNaYVOKAAVj1cZTgn
         2oud5pyS6Rd29L5sG9VaT8RXLkvVrl6hESLC5AtK+UKQUcW7jvgnAAhcuoAOxs3ycEDn
         g6ndDTIgoTTyWnoi8OUtdVz14lOI+Ovan/jRO/l3J4qYko3PDFdypUJ7NZiVjQSOtADV
         F+wQ==
X-Gm-Message-State: AOJu0YzLhUcHNK8059B94SLQj7KT3vLSA+qGaK9B2BJh4C2TGpQSS2RP
	xBINMsDGQ0ArXdxBQj8QSGeiCFQS1pTL21rZj2ljkb0Gw4q4nH4BjAY5dJT2l4mIUDtzWor2nxW
	Emgiy9YMrVhbT9NdlSZ/op/DKfMIy17qN7gieGzuRCE46bGHjNyNg
X-Gm-Gg: ASbGncvYxXvmDH6GQV09vqxlDyfjqCtdxt+1fFse+sE1Cp0iEOLzJUx9qm9LzGfK3Yi
	vXA4dp79ODmNKqwdSRAF+P71R15nBWCpuERIVoWcwYRUUFKGljJwCei6nwPF+dN9eFsAvz154e7
	9T7TWd4tC2zjRv1+yPvffB1Ce4+HfznpVeYVdbMJ32c799mOF0E5erSxW7rqA8jShq1otwbIW+n
	+UcrOk+tFbj/JiTK60dY1VDs1BDA85RSINPhlk6fwylNfb3IFPV+k3iVn10LKkLdV6HZ0xEzfXZ
	VIAirQ0GR4IYPjk8n7RuNtF5h2XliTif88GmwWnujJrfTpT81aWG+9tmIvMiIvXQoHBZeFm2dW2
	bMaZTOg5CA7QUxZXKaIYbwr0v86TXaEryp8QeUYcUtJT/ZPGOUlKSxq6Dvn0A5RFuXhA=
X-Received: by 2002:a05:600c:5024:b0:442:f904:1305 with SMTP id 5b1f17b1804b1-45868b0d92amr1431375e9.6.1753213989691;
        Tue, 22 Jul 2025 12:53:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHsLOFOwTTLmBWwHiT96TIfOP+di28wWAJf4G5/QX+/wKgzO9fEejkJpG8dI/c4Tq3iZBLNfQ==
X-Received: by 2002:a05:600c:5024:b0:442:f904:1305 with SMTP id 5b1f17b1804b1-45868b0d92amr1431125e9.6.1753213989183;
        Tue, 22 Jul 2025 12:53:09 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f28:de00:1efe:3ea4:63ba:1713? (p200300d82f28de001efe3ea463ba1713.dip0.t-ipconnect.de. [2003:d8:2f28:de00:1efe:3ea4:63ba:1713])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45863a131aasm22793985e9.2.2025.07.22.12.53.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Jul 2025 12:53:08 -0700 (PDT)
Message-ID: <24f6b0a3-68f0-472c-a4de-6776997c3eab@redhat.com>
Date: Tue, 22 Jul 2025 21:53:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] MAINTAINERS: add missing files to page alloc section
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Vlastimil Babka <vbabka@suse.cz>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
References: <20250722174143.147143-1-lorenzo.stoakes@oracle.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <20250722174143.147143-1-lorenzo.stoakes@oracle.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: WbRtKmyNuiaEjVz0qjrV1Q0awfQpBi7odxkm1WHoUo0_1753213990
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ekuxbezxrqx7drm5aehzrkpt1nmxkst5
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: DB73A14000C
X-Rspam-User: 
X-HE-Tag: 1753213996-380236
X-HE-Meta: U2FsdGVkX1/CJqFqOAgSdoZ1U73eeeKO37CVhbCTIUzAGM6NG3/bg8RyHT6kUtjxP0RdePtyNx81EiVJ0rJyNDi3R/dVfwOCKxHNpbNsrR87cU2ygCwXfxOYer4jCAla+yFOgY266Dp4rL0IcOifrXjpelAOHAg9PmXJOsPE8pqHNftVjJkC/JIKIq+9a0Qubt1BicnrvTgBL3wH9C5wTgcT+uVvOzg/EuVvyPsj02Crw0fsWM+rT84EAWKxE6bn6c8ANL6PlxXt/5LY+GXi6Wj0z4KLJozKPlLQf7PIUX0FoD+K7JDj1A8Suw0uWOaEGspElEzeXRS9yncsoQvVpQdYyZ8DOPGDmIVnQC8iuZ7KX+8B+z2jTk1IyKRIMspG8UX2oP7cenoAURP8VvQwx+NdAxFwrM1eDkwrF+7n6QSIKvoOKIqrHGqzLgcAx4l1xwxyc7xgJ5KXm5Ah82yJMrQJ6Sf44tUrbe0BeBsHp9uJTbRGPnCOWaFxmuMYPm3LLrpIADJbiOG1Ycd8ZBuhKaf2wK+jwjZSnfFuXW0JZXQHx1/YFCIVSN9VdBexhUvF4Iu+2cYRBGhWU+sK2h6CtKd+kjlEWggImlE6m2fPnd36nNI9ez2/TZLQKl+25xCdZRmuHu6S5CTqR3vjF9ewbOU1woNnPD51xI8DjhkcDTlrgNKHdbKB1zZ4ZvzH6tsecSfkYxYflftw2ExSRB49a/hVfU1/hAWwpMT8jAyzMZoj9J5+TW69uCenuHFTW9oULQ+UH0lLO3RRPHq8q3JZX9pDoDBiqM4wnxWejokoVBxF2/qUWVmyXBpx1cyXTHxevu1WNF21RA+dVY9Rmy5RFJIsM+9Mt/EoKucXDclMChDXhFRlU8dzSQdtwMsGZSSMuTmckAobq0M41X2dVU5oXHMdcksxs2MTNkHz+vqGBsbmnsDUY9AMFc1+qcCTcITolm4fSJJ1ynEL9mVfqCA
 IkSkJPd6
 DfkARlyCL8RG1oeBt8Z8N/b/TP17AwTZAnVAEI0os0I50fcedX7UPOlVmvpG6JH2pSROeGbIjz3qLMedWhrMZGhAFhS/4rHritmGKXGYyYqjPKSIu5mJGv2hQ16RqwTGixco7XKSnbd+xChfyLLaj6S8diXAJMkI9YcwiToCB9s0qHQsfDnU9SWujQykmcIfbd84vhTfKxGDcL2SJSOirK5rxJ6STZjrGMDHjb7DEHmGo0ZndB93+rwtJ8ABNryq5VYelhazQG3Xgo3hRVH+CEf8WPjIO9/iDM3PYMBs6vFeoP4qXVCltczRC8Gs2hX4o7+uSMY9lw0spnyDceAmZRmVlj6+XgW8ZkPS/p+BugK+7e+Iu0i6t944wxgbCOSIB2NDgDMKuYCN+UIZ+D007JswwoA8XOH5lfi01dEFV/0FZ0lYvUVrc70Wa2tHQDKkEzQ2rCkDIwkxJzHbRMQF0TWABsQCxHxpPqeqDHY7tvVP22UwcRXAdEvc7Zg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 22.07.25 19:41, Lorenzo Stoakes wrote:
> There are a couple of mm/-specific header files that were accidentally
> missed previously, and some page ref debug code also that ought to live
> here.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> ---

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb



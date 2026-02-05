Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3DD1EA7967
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 05:13:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2B9C6B0089; Thu,  5 Feb 2026 00:13:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED9646B0092; Thu,  5 Feb 2026 00:13:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAE586B0093; Thu,  5 Feb 2026 00:13:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C62CF6B0089
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 00:13:44 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 59329B90CC
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 05:13:44 +0000 (UTC)
X-FDA: 84409235568.17.DC5F434
Received: from mail-dy1-f175.google.com (mail-dy1-f175.google.com [74.125.82.175])
	by imf09.hostedemail.com (Postfix) with ESMTP id 678C7140007
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 05:13:42 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Ekrfxb6t;
	spf=pass (imf09.hostedemail.com: domain of usamaarif642@gmail.com designates 74.125.82.175 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770268422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4vfmzVCg0tqpO1KYczg0s+VtVqSDCdJvzToKcOgVwlg=;
	b=YcdKIgUu0y0OHB+0Dam7sHpxTV4YtA40rmbuzCsRf5nmxtT9u5dv1FJTW1iF4P5IBkPzij
	UXX9Gj+FavQXXoNGFiDsEKha+77tu4Kt2XZsJy147fk3YQ5c0W6tHTi9OQ3Fit4q3UDejX
	WnrdBuH2qN0OOZTlukfVZu1E+nM2IZk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770268422; a=rsa-sha256;
	cv=none;
	b=CkvT8HPgIfhssJ8IFMpRGGwKJzzmtb0fUp1iL8NbiYJAV1Ly9QNTt/KJBrw4EvIjZ25nwp
	eR1I9VRKkf/oRoi82+XXsI4dSR0YTeVfRYhW/k6QSbJOm71r3F3vft+QHxl3Wz7QK9Ewqh
	xRtMyAcSGEaWvdQL6wC8zwgpFKBbiv4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Ekrfxb6t;
	spf=pass (imf09.hostedemail.com: domain of usamaarif642@gmail.com designates 74.125.82.175 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dy1-f175.google.com with SMTP id 5a478bee46e88-2b729f4c154so831481eec.0
        for <linux-mm@kvack.org>; Wed, 04 Feb 2026 21:13:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770268421; x=1770873221; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4vfmzVCg0tqpO1KYczg0s+VtVqSDCdJvzToKcOgVwlg=;
        b=Ekrfxb6tK6O/eDN2JD2DJFrDlaDaz8oHicpgcqdstsblXSl6mHebI3zi2eSTPuvLdu
         CO+psGWnwejFW6zR/ISJg5oh7Gkn5L2L3aSN2vm6H9wLroXqyvTfOxhIf55acynl5mfP
         hajOWCT4FxpBH/ryY3jL0Kmn1EOnrIGcLU9J/wACBgap1S0BA2NtTkGEgHJjKxOiiPP7
         xB1naVwlIhvv7sjT98nmZ0zeq0cwk96eH7CiRGTLw93uGSQmLiYYhbgjqtU7/SiLArym
         hfKQgpitzuY38HG1HQCMR5rYcCX56i5b24c3XvZxt9D5kciwfowfmKFXnu6XzlZNNnTc
         aUZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770268421; x=1770873221;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4vfmzVCg0tqpO1KYczg0s+VtVqSDCdJvzToKcOgVwlg=;
        b=UGG1z3b3tqYlfK8wam5Nuk7UBa01bQ1S8tEWou13s9ZDHBTd0JAoLNre2VI/+13D4A
         cIstevxQkmNPc8i3dVP9xKg0g60KuwmNMw8MqqmzESdzK2ymn00AEnnDZlMBgK7WUwYk
         dmHiAqc48uxl7ovJNBy6/Kv7mCrTnUumAlG8/zpp0lEl2qjMj6H0QpFpi2UtLnH2OeQR
         3LlBWEoIkH5GYgnOP27dye7g0ty3gHi2KFyEEar1QR0F2fm+TRkqTqOshXc4OhMUZvJp
         +JF6cO+xHXyTyidT7Sj7MHQaw2TZOmsW6G1w3kHkT9BJdBn3TxYRmw3lWRHNjtU4i603
         0eng==
X-Forwarded-Encrypted: i=1; AJvYcCWFHTGGSqRnbFsvoj7IMsItVOH4AQyzKQq4yog/F9WKb9MEjfFcyTD83KlVywKV9gUaN9hvg5v4zQ==@kvack.org
X-Gm-Message-State: AOJu0Yy9asHZXKadq7nDEYd/3ddHTWhJuwL4n4ZM8zmn7eBVpZhehFiu
	Gi0XlU11ClhtjLrxzvyYgmBpR7epVr+NP6xROSMC0J5eE2053xgC5DMi
X-Gm-Gg: AZuq6aLfo6kZ0jJ8AaosSYD0+kVZGBgSBXl/ZKqbAuz+peNUyHKXG7g1X/6BgTsEygh
	gB5QpaB3r5W84ANgtoQzMjD6CY+RTDR+MjXxbCAze0Mvyy0M9w4jWKS/xLKxmtpMrMuB2Ur25kz
	zm3scHg1sO69ESIV39svdxcXONAp7u/ZC4p5koVW2KkPZEmrWMyRGYiHTPVnLuM8QssQnA5AszT
	ASCUnkxAaf75hylLFCMDYqFNkI5PHRtdHSZefevM0kp/687hr/VEY0uh/lUpMwMIOQxqn0KJGS5
	P6grDdxwn89kqPbupuWLe6Tu9gD5GLsELuO6g20VXGTUV3vsaG659hRXXjxUQbfk4mA9nA+X+A/
	suJKQpVdUv6JD6PEeE6m+g7PaP2MOUIrZgZGHXVVpzSr7VvXaPAIg6zK8oqzbw/kcls6kC4TBJn
	HHe95PNvqd4tnIuS0YsHPr1ATyI+6DU/S19hTcdCTFSdRz
X-Received: by 2002:a05:7300:2303:b0:2b7:2bf3:ce01 with SMTP id 5a478bee46e88-2b832a7c450mr2214121eec.30.1770268420982;
        Wed, 04 Feb 2026 21:13:40 -0800 (PST)
Received: from [10.36.158.92] ([50.175.227.221])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b832f91114sm2514097eec.20.2026.02.04.21.13.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Feb 2026 21:13:40 -0800 (PST)
Message-ID: <945064a3-b6ae-4257-afd7-5229cf8267a9@gmail.com>
Date: Wed, 4 Feb 2026 21:13:39 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 01/12] mm: add PUD THP ptdesc and rmap support
Content-Language: en-GB
To: Matthew Wilcox <willy@infradead.org>
Cc: Zi Yan <ziy@nvidia.com>, Kiryl Shutsemau <kas@kernel.org>,
 lorenzo.stoakes@oracle.com, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, linux-mm@kvack.org,
 hannes@cmpxchg.org, riel@surriel.com, shakeel.butt@linux.dev,
 baohua@kernel.org, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 npache@redhat.com, Liam.Howlett@oracle.com, ryan.roberts@arm.com,
 vbabka@suse.cz, lance.yang@linux.dev, linux-kernel@vger.kernel.org,
 kernel-team@meta.com
References: <20260202005451.774496-1-usamaarif642@gmail.com>
 <20260202005451.774496-2-usamaarif642@gmail.com>
 <aYB75cWO2nnTx2ch@thinkstation>
 <63D23D5F-AF35-4199-B52E-DFFC16DFDF91@nvidia.com>
 <05d5918f-b61b-4091-b8c6-20eebfffc3c4@gmail.com>
 <aYQZzw8kJFsy1mMW@casper.infradead.org>
 <aYQar8YiejRNCqE4@casper.infradead.org>
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <aYQar8YiejRNCqE4@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 678C7140007
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: hky9bmwiii76gba7pjjw9dpaq9nrzeb1
X-HE-Tag: 1770268422-637969
X-HE-Meta: U2FsdGVkX1/plv5kNtgddAm116kfOUUjqL0fpQGzhWTunAJMkCLF9k9vhqeuHK0X0hTjMWTgU0R35opQtLx5xFDtXB8w9n/q+ZjiVqvmUGfaB+lUk8KJz5JYtCswNdOaqc69dW334ANof/9YVXROCv6rzP/Ch5OYLp3kjT3BfGrYqcliKqbWkQvyzgxXxbrN5IldATN+opcUiAT4FFYnIcMiHNivJg4J6Es9JfAK912Ummzh/fiDk8wVu7Q9hyaA7Se56lPOagw3Q1I4r/2y7g0jqcnIfvj6zb+2NDhvBwl5zXDH4S2Bi/7yP2PrTA9upWi02lYGoQbWv+n3w714Lws2lqhYnYwbz4ZgEEocQW8r9ZPcKUV8GC6LT+6IkkGVhhWaURJpx/HE+lfK71u8nr4/mH+EAx/PaXtihLnbMO+dMFUDzupJ/Q+QU9anfjdsRgJ4BDB3dkeXBw7LTH9F8YTD7Fqb2UIfU47qzIgrffmJtwza0x4JM+u3aSRt4HsFY2Apyt6OvY3pXAiAnx0JwX/6ycFYUEWGvU/JCkg7kyRRIhmMqbc6mKTF3qPZ4RA5SZQRKx+y9json7GZJHoX3JJ+A9l3Ck5VzgJFRvYfCObMP+lH3qwxpu4973YSlYYq1YJlyQ6YlfCSy9zJ2DciIpVONqQVH3qwdYQcT4btTKdkuB1CdtTtzLKBmoETI8rbPcXi5L+Zxr+MOlvOZu/wmNC96JC35s2NkzfKNG/WifsXuFQb8b4IAB9hPrULGXpY3Y8Hy6g1y5AdQ9feW1+FEYhzGEx353JKikB5ae7WC6za9PuC7D/cinAvwAgt1CtxFhUxVYuFB2DR+zufsAn8xgJtuj4gHW5AF/VX3fkVR9PY2iTp6qz4PtYUdx/ECKV594FvItWNYsh5CMcPeTblxTTnoe6+UTd9oM307Xxn4u0bOkluzuUGiCyQ/pkHgbv07Q5Rg51qUjJNeCVuDWz
 kvx3T2Bd
 F9QL0m0j63lqj3D/6g7ILCb713P1LgUx7pf7kUGqj2tD+oHn9lFzKXq1YZHu+gIwUNwer43da1GdmaHzJlTODJAQnfkxwCdy1rBvhjPBQgYSG5KE5LLhaFcKAHx9eCKh8XwB2y1ilr7CGZPSjdYE6lXzx58nXD1mK0azjNDyzA16nGvxlv0zqayiyJI7nBDIhMjzyQcIjbgSz0ghi38LlNAz/JQFxLDzw6oOaS2O6r2ovNkyXucqhbcMStOyXZCMdtdrQ65OtR+QQ8VdNdzp7/46VJC0MiuHzAeQCrJYI3WD1RZ6eaJ/jE835GXneriMXovJ/PTx5JqGxR2+kBFsA2pENqs+30h1mYIf1/dn7m2btqMQp2TxHtjhZ/SFe8TmJwnPiga0Bvd0xIIgTvmsly2m7rSqr/2KJNekgJPrWmmoEXnYJ/kwn9CagLT7kEwg3Sbm4BIHClc7FzEz+p43kkYIQN8YUxa7fI5hUW0tDjDEe+yvr4+xXAqc+YEYl1O+xNWa0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 04/02/2026 20:21, Matthew Wilcox wrote:
> On Thu, Feb 05, 2026 at 04:17:19AM +0000, Matthew Wilcox wrote:
>> Why are you even talking about "the next series"?  The approach is
>> wrong.  You need to put this POC aside and solve the problems that
>> you've bypassed to create this POC.


Ah is the issue the code duplication that Lorenzo has raised (ofcourse
completely agree that there is quite a bit), the lru.next patch I did
which hopefully [1] makes better, or investigating if it might be
interferring with DAX/VFIO that Lorenzo pointed out (will ofcourse
investigate before sending the next revision)? The mapcount work
(I think David is working on this?) that is needed to allow splitting
PUDs to PMD is completely a separate issue and can be tackled in parallel
to this.

> 
> ... and gmail is rejecting this email as being spam.  You need to stop
> using gmail for kernel deveopment work.

I asked a couple of folks now and it seems they got it without any issue.
I have used it for a long time. I will try and see if something has changed.

[1] https://lore.kernel.org/all/05d5918f-b61b-4091-b8c6-20eebfffc3c4@gmail.com/


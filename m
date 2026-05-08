Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E793CD343F
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 01:00:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 40CB76B00CB; Thu,  7 May 2026 21:00:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E46F6B00CD; Thu,  7 May 2026 21:00:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 321F36B00CF; Thu,  7 May 2026 21:00:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 215D96B00CB
	for <linux-mm@kvack.org>; Thu,  7 May 2026 21:00:48 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A643EC23B2
	for <linux-mm@kvack.org>; Fri,  8 May 2026 01:00:47 +0000 (UTC)
X-FDA: 84742447734.02.9E36103
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	by imf24.hostedemail.com (Postfix) with ESMTP id A56F6180004
	for <linux-mm@kvack.org>; Fri,  8 May 2026 01:00:45 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hkWdqP0s;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778202045;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xfGLfBB9pvzUSSavaG5vNtkZXqVqIkKXeFYpP5mMAEQ=;
	b=x4YIsDKGSmf4qD3+uXoaS4ykLxmWxlw3Li/dA70WPMEISJlq0VyUPgD9RGSwjnZONHHIZ/
	813Hzpw47siMc7f4KwZL7j4wzYEslDJXecIkFD7q/wviP/XHwNNBYY/rQUTX0riRFvnaHG
	P+2EfZKG+xjqME65bj0csQQSvaSGVTA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778202045; a=rsa-sha256;
	cv=none;
	b=s2oUKhgZnbrrLD3dIHPIpPezm43VGU/QTmpHveHEqYl46/uXEo0acL9B0ASrjKS3B/Gwu0
	j8Cn6hDfhaFBdhebK32i5rlfVK1obCdAgmUXVNl8Xyg54IW8SbiHEW+6vKZGZPB3fdbfIu
	9VAh/ceE894MZVlGJqIyMM0gxmWu5HM=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hkWdqP0s;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-ba3115fe0d5so480373666b.1
        for <linux-mm@kvack.org>; Thu, 07 May 2026 18:00:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778202044; x=1778806844; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xfGLfBB9pvzUSSavaG5vNtkZXqVqIkKXeFYpP5mMAEQ=;
        b=hkWdqP0sg9iYo68BU4oZqqUZlBW6kSAik8aC/HTeoNUErE3kaqAedhoaefXundgjKJ
         Plz9SOlRLldQz4Lsk9eCRNURDWAplIsagIgzNtVaxa6slHeeExM77ndO9wBDTb5LtFyB
         tsUwVar54SFDQ1urVXioTvNzURhGt1D38KwF/4F0WBxNbpJTcWfY2durhpmpdiBbrvVf
         aNsKsDtGzenek0K0KqYGzIDflYtowXlp9El8bwM3Av/TrVGV2Kw4bDH29rrpY5Ez0oLY
         5gfXDJGQamD2kP7tO31KGLN0y5QfkgZFYSxOo3+S85E2l2tb5NoEZgDqOHugQmJoNnaW
         PrTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778202044; x=1778806844;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xfGLfBB9pvzUSSavaG5vNtkZXqVqIkKXeFYpP5mMAEQ=;
        b=lOIIKuiEa0b3rXs3TVd40G4fwaQdfDJh5UgMPigNuV1wQu/ptgbmAmug1qIm/hcJBn
         mATk0p4a9nK+SSXOoyKmDv4nUoHlTQEkWi4BogUcjAFhMPRCMm/hcxvw68XcUJVoTUce
         f1MQFMnOMu90oiN4q4FVnZSWmbbJc7g8VkIdeywiHVorKhFP0VaBOHjlB4BTvn+1wTil
         VaAxCltuwuj05OyMUuHxINr3OAQbV6qWp/vk7nAJFye8S3PfjUFkPi+IjrpPno2/ucJI
         AjM3aehuUkTGRv408JxuImXc9JwAQ7FfOH/6v5f7ogQ65forRh7pT/2lEledSz8NJgdr
         jkzA==
X-Forwarded-Encrypted: i=1; AFNElJ/iHBFz4qiJKPfKGMEmWV0rDzhLCowJncbb4KPuxOpIv+sPALMZcX/y9w6IAMgPs/aUX45EiL1XJw==@kvack.org
X-Gm-Message-State: AOJu0YxZtQsdB+dHuIupGVsDJPTIRv8WtOiv5ZLqMqvzzaoMhwfhRbzG
	ikUv1JhTUSDRnZBFBor11pyXFaMGXJca7Tg4tsC1dJh3NfK0tLxYJVqk
X-Gm-Gg: AeBDietM3/vBj5ZTAcEFPEtut50DvJUKVlXe0uT0iQiBR/GH7rltGjCc+gpQZqv/mQv
	TXRijPcF81LcBlscaQV8Dzbc5vrT49uOiKK3y+Ds7ueaJw2K2Nv09KGHC/nGhj9GFcSo0tfBxcz
	gD1xMbC/6wvxnE7OlPWacPcyloxFZGswnYtuCzHJQnbOXSuC0cxxVoVnQRWgWIAOWiunWZG1FP6
	6TJAq0BOQEK51krQXVH3rzjW2oaZKdJRWom7f/0U8TZY/IavW2LHV1Bi/+1azCrzPr6E3WMF9Bl
	jteF6gQIq8tMlHcSbIFXOoSIZiTEwJsPFH2qA3/9uCD3zueWzolN1MuUK/GsEZJt4oYJQCNYLP7
	vGX6nhKpo85KXsmfF8rY7dSQP9nf+GH8bBBlZqltuUvdI6jESh+kkb1K20UN+6JeI0CbUhWVMNX
	ulVu2CCX52MEBYpuuti7SZT8BrbKdsplg3
X-Received: by 2002:a17:906:ef01:b0:bc3:99d5:a29f with SMTP id a640c23a62f3a-bc84cc72ec3mr272203466b.5.1778202043620;
        Thu, 07 May 2026 18:00:43 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-67ef0dfd334sm53826a12.16.2026.05.07.18.00.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 07 May 2026 18:00:42 -0700 (PDT)
Date: Fri, 8 May 2026 01:00:40 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Wei Yang <richard.weiyang@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Oscar Salvador <osalvador@suse.de>, linux-s390@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: Re: [PATCH v2] mm/page_vma_mapped_walk: Use ptep_get_lockless() for
 lockless access
Message-ID: <20260508010040.o7bypjnfceeqloeq@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260504130434.2285053-1-agordeev@linux.ibm.com>
 <20260507093433.q5xybwumryxclnqy@master>
 <43815634-29d3-4fa4-b967-0e251ff32f73-agordeev@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43815634-29d3-4fa4-b967-0e251ff32f73-agordeev@linux.ibm.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspam-User: 
X-Rspamd-Queue-Id: A56F6180004
X-Rspamd-Server: rspam04
X-Stat-Signature: k1b5sbextyiym7897wb3d997on6byexg
X-HE-Tag: 1778202045-485820
X-HE-Meta: U2FsdGVkX1/Q8mSvn2viXED29gWJYP4SM6iySvqshzC1713U+KfDvXqYzY6CD5ldqyZZQnkV3ApLNFJUEZJw47jKGGa2gtrputS/WLJ2/+pDXRBtGUVjDe9BOZQmTESTS11dG8xPE2O7tHQuw5bzgyPbpknTZhCnnu7iKTke2aMxbYDpO1r5P+U8eAjBNjd/XwBso+JYXQY/TkO80ZWmAg0JKMh2TeNcihxk3x42zDL364VnzbsLdulbbswNmxC06E+DsOJVTjDWkbYmgdVpo6zjtuR1qxE8LyaHSUkfZGFZ7a+4Il24SravwLBz96fP8gx2aWLc+X+k9icEp/1Ja+2Bru3kE6/03SznnfY2DaHFz1xCH0IAk5BcxnbGjagH2JGwwG2EF6hcFWtp2JnVyARbGX1Eo4dvWcSnpLbjRKv6W8TnDLTI60cF8B5ZocTuKKsbYwDeNtbe02+5KrdiZiYAR8MNB31rGHk+fGfAfj0xCdfuoka5npH21GJ0WSS3Zt9Y1V5l2/at1fCntbi3Vtj1bEDAkyJAl7p40uhOu81KwOPc94yZUq1wYQ10BcS0cUfzVjnr26+NAWrhsl9RntyPtXaZVA7JLetGv8QCNbBJIywA5PU21yxdu1AxBxmggIdpAM7u7KC4XCvIl/jOJZ7AsRhdGOzAPKgTL9MiQoFAnVa1NKhICLt4xTg9C6k3tJetqteyir+NkF3u7gqFv58L9cWPV6PabFdfPsxY6xKxJ4/y9nTrLKN3hbTvzIimwjxq0yiqhP+uw+7RmikI/iINtfsp79sljYK+dkVBMxBc06CW2tQfTnw91ULp2jaE4yLwgYIxl99GdX7HO38yJ802odMHaSVnPDE8vOo5b0FSHPaqQA7fYiAiN8XhWPieA+GS0cWOCMg+uBn0fJ1UIbeHjWiARUdNRfKrOpTNQfTEezcLs/sW4/hip+EoS9y85XyhG801oVBjrD0vx36
 /pHoMnub
 2hJPmwAcM7GwTaC54TuJeBUzLjLiMA4eKaY8v6wMa0bqvomPs2qXcAwRzVOp9U5RtwrARr1LU2ejxTBYWTCLTYd/ZW4fZZdI385QaB4o1my1zVxx1w58ujJ4dlHkMdKtoYiAdGNZRazEXeobNB8UQcTaL/cDjFxjx3/OvIBujCjREkthCc7Tw1sliH/eyDylvcDIiyHXpU0v2gJyYakGsWFqep1o514Ngzm5xDb5o6mUn82LohcKVWvZoRC8NHIiNqY2g6uyr7nnIw9RFPF+zISE5Idtox0iO9FMrqu0DWDnaXOja3nlDUNNKGh9iAYxKr7xI2xjntI9GmX+S+6YAA/nhn6P5P5pn4EgugbPlDVaydlgjEZHrOjyzuRNW/EWAecoNYnPT2Jo50DIT7uOQ+rPge3CcI66CeI9T7YlqbDI5yNPR4Xisgbh2L43OBtUjCwUpNbUFdcU76akjtNLeIo22VaAf4kIAM31yNYpYqhNGNYh1ZHvmIbjF/XMNbaIsFh1Vs5XSqLASl/xCdhJ5semEdNIxgih6n0iUh9rro6654qDl6PK8ePKt8eN9VNZOCa7S3n9Wl5GwP9OdPlUs4GkM0z/JIQ8koxBO9UnukktgbUUpzXZFrjEvYtm45lyoH1dxtTMSH9XyRlgv1C8Xol6rSpn5TfcKVp1Rdt8qa+VOvEpq9CJ4eF6GhSl8JAeIpGomxJ8LZKvxjA7znCOBhV8rNdr8BjpRj4O5Xs9cnGfJnRo7VYmjQmc2p5oCO+//q37rS5E4db1pTv5TrlAKVIMeT+zoCgzG0ubvK9Nio7Gn1Jwvob3XoB6EXKcFnB4cNFv7pvx7WGFmTZbtirxojYi8gQBWyllSaxj3Fg6USDgWpt0YNOAKeIJPT0DyIhk1qlx9fPjXlbZEYx/KW49JSex1Pw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 07, 2026 at 12:32:09PM +0200, Alexander Gordeev wrote:
>On Thu, May 07, 2026 at 09:34:33AM +0000, Wei Yang wrote:
>> >@@ -310,7 +310,7 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
>> > 				goto restart;
>> > 			}
>> > 			pvmw->pte++;
>> >-		} while (pte_none(ptep_get(pvmw->pte)));
>> >+		} while (pte_none(ptep_get_lockless(pvmw->pte)));
>> 
>> As Oscar mentioned in lkml.org/lkml/2026/4/27/630, map_pte() may take the
>> lock. So probably it is not right?
>
>If I read the code correctly map_pte() might take the lock, but also
>might not take it. If it took the lock and uses ptep_get_lockless(),
>then it is fine. But if it did not take the lock and uses ptep_get(),
>then it is an issue.
>

So the rule here is:

  * ptep_get_lockless() could be used for locked and not locked
  * ptep_get() only used when locked

Right?

>> > 
>> > 		if (!pvmw->ptl) {
>> > 			spin_lock(ptl);
>> >-- 
>> >2.51.0
>> >
>> 
>> -- 
>> Wei Yang
>
>Thanks!

-- 
Wei Yang
Help you, Help me


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77235C87FCA
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 13:34:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB0626B0088; Fri, 25 Jul 2025 09:34:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C88286B0089; Fri, 25 Jul 2025 09:34:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9E686B008A; Fri, 25 Jul 2025 09:34:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AB2396B0088
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 09:34:12 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5B85C133F0D
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 13:34:12 +0000 (UTC)
X-FDA: 83702880744.16.F0E84B4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id D32EC180004
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 13:34:09 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CWv7NeuF;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf24.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753450450;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qjzMjUgFyhocxCtvsQ+BuNp/oTUhZgO65l7SMnRUajs=;
	b=1l20q1p5V+0PZW+LQIEovPobMhrVnijmdbFOk0Gd6mkevDLjcgy5ulZG5LQCer+ksWO5bu
	3fKIGIN05+QG8sCknV3i+21PDRXkw9MImNwt/rYXD3n4nQrc7qpa6KRRe/t4SunxsFSa/g
	iWkqmwukHTtPmBgF6uud9JnOeTovZ10=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753450450; a=rsa-sha256;
	cv=none;
	b=IFR8Y3/raJtKIMtQC6A7nvIqlbhGza2HxVhP3cPZa/Zh6Zk6qtx52LTS25TvEwE102hEB3
	u8nuZzem3l9KlZad7suKDFgjfms3SFZITCt2YSQcfOWzYUequmvgZuTi1cpdWzr4D4N2z0
	csNJx6khjLktSp22qhFaEI+C4SghtEw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CWv7NeuF;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf24.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753450449;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=qjzMjUgFyhocxCtvsQ+BuNp/oTUhZgO65l7SMnRUajs=;
	b=CWv7NeuF6PIErdGept6VPtfUWsZZlOVhXIz39kd0m4clWtKVyF0Ek6MO4xBPT84+JjpUxl
	FMtrFN5ccbJYOyyjQjCsVhcz+Q38SMbgyJPPhamKOjZqU0hkOiSHDBfeaJ559nXExhEuzv
	ExSG1dYevOO92u3m5UFcipAKkAzDTpk=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-614-bnxXs3aTO2K4htrIQ8oakA-1; Fri, 25 Jul 2025 09:34:08 -0400
X-MC-Unique: bnxXs3aTO2K4htrIQ8oakA-1
X-Mimecast-MFC-AGG-ID: bnxXs3aTO2K4htrIQ8oakA_1753450447
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3b775f1236fso331200f8f.1
        for <linux-mm@kvack.org>; Fri, 25 Jul 2025 06:34:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753450447; x=1754055247;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=qjzMjUgFyhocxCtvsQ+BuNp/oTUhZgO65l7SMnRUajs=;
        b=HhnBETdDmHWhq5DVRQMXPXLRCAXbixiNalZxm/RE3EayB6D0lHpXWg5HHY+wVfVRQb
         zYwLw1VEoxqnDI1R4jNIMuhJrSfv24uwpO/clSl7zU35Ug9cUn+nGT9aesuIMEusqFmb
         2tggGHDV9h37ESpKUjpIlSi6xtuJi/sP4xLbTIkdIU9MCcAGTG3UXvfiSFs0DPPK1gzi
         IV/iAXeV4j1rJ5LiOP19J1GMYXsrNGfZtgBHVAp4kCWxTc6HitvO4YcGHHAUA62Mvgmo
         wTH/Ip8VI7MZPH1O+KxMwSIoytSSCiO82OPI+sOBmbjOhUG8y/XEyzbQyC2fx+DPiEOa
         7qbQ==
X-Forwarded-Encrypted: i=1; AJvYcCXJeELyQIKy4JQIhbS2s8awGUlA9J6QT6guvjp3PwzkdLCtkDI7qehAWu/q36YVVY1rjwQ5lwLgEA==@kvack.org
X-Gm-Message-State: AOJu0YyPYmdTOwYIh+D6xzq76ggazj6rbhfW3aB1LM8WAIAzFfRTp7xX
	3/XFB0xmFdT5n/senpcep7vy44zQJC3wL+ROb2SQ58UCJOdCIQRBpx86oi5SnRGIZrovqVkH8yj
	zxSO/DcYHc2IH0YJIIkpi8itTxTYZRU4CgaAXBZt39c+JFsJjpCfo
X-Gm-Gg: ASbGncu8Jbu7z/LbI54smFUNSd0K30TK7vkXwxfoL8l/IDEraixiZL+9I5qPapfOMhs
	77cbckXJvanNOu0nQ8ORtuF9Rd4vLSTe2VWEoPpdPIsQxpIOO6Mypzp75Y6z0ACMuPXFE4jz3dh
	LQ4IxplmFlbYpan8ELAAMgPcGvY8+6wtnUrxqSslzFeeuBoVdg+fm4P1/bS8jlnvX6QHxziV05v
	J1HtJNh1DLk+JeaqaxX3YpVgHc7Ec/V3wtUkPAqIjzDBz45wqcmJzPQPTARePKzrbGrO9nX/RDU
	aS0xMXXYbQGOgBOTOZTd4I9D3m4ivMLpzAdLk7vD58cL5UnVcgtd49FNvR//n0cY+Vsp2j2vB9p
	qyEqRZywlvCKkQZfjdShzhxqARR/oDWvtwswdHswxK+fJeOtjTcI9YPir8DwX/E/c
X-Received: by 2002:a05:6000:4387:b0:3b6:136d:55de with SMTP id ffacd0b85a97d-3b7765e6081mr1825575f8f.7.1753450446603;
        Fri, 25 Jul 2025 06:34:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEleK9UMiHt5WkhFPdIkFBwXAyimA+Jk8S8JlFb61PWfPjOgKNNQgs2/x2srwaWvJHl9HSEow==
X-Received: by 2002:a05:6000:4387:b0:3b6:136d:55de with SMTP id ffacd0b85a97d-3b7765e6081mr1825546f8f.7.1753450446066;
        Fri, 25 Jul 2025 06:34:06 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f34:ae00:cf93:b0dc:6bed:abc? (p200300d82f34ae00cf93b0dc6bed0abc.dip0.t-ipconnect.de. [2003:d8:2f34:ae00:cf93:b0dc:6bed:abc])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b76fc75e7asm5003077f8f.31.2025.07.25.06.34.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Jul 2025 06:34:05 -0700 (PDT)
Message-ID: <75afc906-9a09-4c86-8d70-f1c42a2ee4fc@redhat.com>
Date: Fri, 25 Jul 2025 15:34:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] selftests/mm: assert rmap behave as expected
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Rik van Riel
 <riel@surriel.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Harry Yoo <harry.yoo@oracle.com>
References: <20250716082710.2801-1-richard.weiyang@gmail.com>
 <20250716082710.2801-4-richard.weiyang@gmail.com>
 <c4f339de-64d8-456b-bcdf-3719bea08fb1@redhat.com>
 <20250717031748.27eic7qxotft6uko@master>
 <20250725021649.eetoa4sev7r4uweh@master>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <20250725021649.eetoa4sev7r4uweh@master>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 9GQapovtLLWIvYHa2ej2RY9NFGrEs4FSTunJqcZWAL0_1753450447
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: fwbwpz41b5gexb6ze1yws6j7915qy8p1
X-Rspamd-Queue-Id: D32EC180004
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1753450449-980671
X-HE-Meta: U2FsdGVkX1+cCjeGnTfebkeK5hxCwTGoohosU7hR1/iI/IBcmImAzuow99qzlSj3M2jx3A34ib3zrDimMoozgaVV7olxuy6yVCEfLlMTSWTgbxuLS6+O+bk5icrJ3LAHqWxSl92AExZu4mKmlOfrK9VhTkX/BQb3oUM+zb56BzX/2SroSbNuZetg1PdEVIGLaK7GJgKUBagK871NkhLnHz47lYf1wSHaimxYMJFlZLIqFvZ9nZsTSMnYHxIc/xHQmFPLkH4XZSuOlj90G2jEinFse3qS0s6IMhZUaOSuJFqTmSRu6qLllHRfGHwUn0FJWjYe1UKA6/LzNb+5NZDwMwrWFZ72pRg9bYzH5YM1QXIyQFJR9jPT4iXoGcnrxWuptPHxs3ZQ715T2YID9/e6bJCtVy9a61XNhwJQYWzw3k458HSUHEPFw3cJDf2DOgsgsp3TgEOeBbLEoDj+4Edm15Cp7AUpAdkqlfLgn23jxP1whHTyydPdfrhyitQWbD7DuddEkfH3uy2fAIn4NdAXcLDHd5uDEgNSE91NPlibfZSWaRSzeRFt7+qkgmczDNJP7LIntEui+dzTAf4aBk8zO325MnqsAnux8XTJpEWEBGJgO5YJW6R+GY3m04x2dL2p2TH2EDhNFCfEenUqLq0FIa42qIp5pev3UMiKV3RmIvGYF0IcyRxp8qMT4wO2D7NZw3xfKfhhmSmGEFYRHw7X61DwzXF1Qf5gpFPuoOY8afeNlLZeeFXDStDTgn500kmFxCg8jRD55Xetd9tGTOMJtkWXlcnfRexzyv/GF9RbAGcErT+Ztl+8moehdqLwzbA+YTrKh6qGhhG+K1hQLkyZNVPtMXU7UwBlkjwzcnNWuDk62Gx6QABIrWLtWP84VcwUZrGC3dRRqhWr9gDOCdmt0bO/RpsaI6mkYqqHFH2Swoaas+b7oqSg8CaQsZKNQ8YNmkhTKn41BRQhoWnbHZD
 lP9Eq/Y6
 ek9CDHEpwm5Rawr3zHTgrRZXTjmqbdoL3EmYNVbP9TBx0HDBDxYNoH50phxLgjVAFu5fwEzt3iDgl1Iyi7MhtmPoiLLtstnirYBGnZkyQqZ5TO425mPEbyzEW4EuhCBPKgb1a4vWUSVqbJ/K1azpwhjtMtHbESrVFtbAEvXn4uxHTAiZu3eeF+MUBrBfkPrhfz/97z1prP41ZC7dqSJ1kkRaA/rA/BLj0SJDUemqv4cGpfn6W2r3qHurdRIogGMl/cWb+TqT/zEXEpjbKLFcQL1myviegXfYuwA8FBXXDIRZcdCml4xUlvkGK+bUyM469pv7zRrMEtwZ9UB/jUfWGWvtzKAcMPJhH3jyym3kxsAuG2YyQFkGAjxgpHv3YwkwDMI3tW1epnOjESmaq3nc1c8dVPMATcsWWOunM5TwMMvK93nGRlTW5WyhjSV68oK6Cmqy6u8b6TcH4yPydiL7t+GlPGpMQCwsrtiq7kkjqUOS3NyfSX+9L7kHzvNNnBjJTMdf06kytooS4OlFgWtAkDRw1mDroueP3INEZy/vs3DgKdkEXsAEOgCDvxg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sorry,

>> So the case should be
>>
>>   * mapping (MAP_PRIVATE | MAP_ANONYMOUS)
>>   * write some content in root parent
>>   * fault in for each child

That is not required, but a FORCE_READ() would also not be harmful (if 
it would be done by your common code)

>>   * do migration and record pfn
>>   * then check pfn is the same in each child

Yes, makes sense.

A new version makes sense, so we can have a look what the new state 
looks like.

-- 
Cheers,

David / dhildenb



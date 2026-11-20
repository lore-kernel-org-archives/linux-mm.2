Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3765606A331
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 12:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=f6ce5qVn
Received: by kanga.kvack.org (Postfix)
	id A937F6B00EF; Fri, 20 Nov 2026 07:10:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1D406B05B0; Fri, 20 Nov 2026 07:10:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90C376B05B4; Fri, 20 Nov 2026 07:10:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6A4FF6B00EF
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 07:10:31 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E3F4FC0EBB
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 12:10:30 +0000 (UTC)
X-FDA: 85455380220.05.D8EF399
Received: from mail-dy1-f169.google.com (mail-dy1-f169.google.com [74.125.82.169])
	by imf02.hostedemail.com (Postfix) with ESMTP id 3627F80007
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 12:10:29 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=f6ce5qVn;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of joaoanandalima@gmail.com designates 74.125.82.169 as permitted sender) smtp.mailfrom=joaoanandalima@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795176629;
	b=MCRMf5HNGTqjURNgziUVXp7rdeae044kFi3RC4VklgnMGhr2fbW6nXqkASoDr++tBJm5qx
	y1htdJP3nqCeNXKPeLJckKcaxs27Nn5tR78KyZV2Lp7Bv7BxwIRsUxRMOGp5tOyVcK1ytd
	RzqFOV+0TrfIBJXpOLDIbrGFf7FS1jI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795176629;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8LFlvhRHi+itjw6FtpQ77I+jdKTUhIGZUp5SZeX1KPI=;
	b=lnriDEC3Q1ZojD6RQKx2oEFfPKADz++6kDOh2h8g3Ph3e2Bhrd2QT55geb+3nkthFtUvA3
	fNRpjubCcG1bFTiJBt3+nqprq4ICsFxNNn9EsQ+xLXVLm5J0HOI4MVwuZyTe8YOZCKigaS
	mgsi5ciNt5AFvfw2KBfclWNm4cDXVBY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=f6ce5qVn;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of joaoanandalima@gmail.com designates 74.125.82.169 as permitted sender) smtp.mailfrom=joaoanandalima@gmail.com
Received: by mail-dy1-f169.google.com with SMTP id 5a478bee46e88-382c3c9671fso1119396eec.0
        for <linux-mm@kvack.org>; Fri, 20 Nov 2026 04:10:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795176628; x=1795781428; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8LFlvhRHi+itjw6FtpQ77I+jdKTUhIGZUp5SZeX1KPI=;
        b=f6ce5qVnX1ybbvFV4xnjSkAMzMa2MDcJ/fh285KgkiTIApt9e4UszZcZcnAoAMrtfO
         NRucf2ZH0Jd6uelkJYinSIcpDzPteumJaQiBLWJieqjGNEFFigh/8YwBn9nqoiK8grZ1
         N3blyXYMVT9xLO+98Y8kZy+Ht1IUnYcfwFb9FRRpaX61phhS7WAbP2u5nHq4b4WFaTNY
         ikhyuxRJjPOH1s4DIHKaNvP5CXn0zRmiB/g4mr0An4KZ0MIMSoUQiOS3InS6lzaknJV5
         hv0o/yl2/AkzdsFqI0GExEOzEWBqk04HnGuLTi9q3ik0Bo1emfVWj8q0+O8QSsqEOS2O
         wEDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795176628; x=1795781428;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8LFlvhRHi+itjw6FtpQ77I+jdKTUhIGZUp5SZeX1KPI=;
        b=D+UlQIRMAk9Ct+l3LVw+cssXbGOev2vBMhdySk37hGrhez6YXkUNhDDl9mdx58PgAE
         jxFRrJJ5aPP6YdWZjWiBU9LpLnG9V5gbBdPBSKSfTWihLtBmj1mHtyldb6RU42olcbA5
         DHy9wZkyYclnF0/Rt8gMNcFvBbwMkVHRrovqwtCrpb7PS1VGY4wdi1S56Ix7seBB62sP
         eGMnDpwIEmnXbeWfBoML9ESF82wMiIxzDLA1k3+W6r5JputfpYwZr+Gu0jIF5uZyOZl8
         f3j8G0XNfvXIM7MZ3JFUY/MyZw/g9mgwseLaOLkP/FQv3jmifPwrpmvNFqwH7Y9vfdAN
         4I7w==
X-Gm-Message-State: APuU4Z+CKpBiecaIRLu4GTsaVgNCza5hCIfXw+XMF91eFfZKxrlzZJcT
	GIS7t5S5LHzjmXwS9AboOys47cWZa6YU7JjS9kERCuR9BKXJIiqIGnOq
X-Gm-Gg: AZFdTZc0b6K25PzT1yXI5Xk3ilx3I26U5Zf2lJSPqZRihhsmcDOMuJQDbH8v7juO73/
	WyDdyBfMujeGd9ST71LU346To4aHvOxVdZRlV5nTA4TQurFgGwUo1L3m8KVP4oHLLuuc7b23TLx
	ub2+d7x/fzeaFOCy6aLI71TftJD40ck1rIygLmwTHVGKHneMgnTQ8dcBU/RTnh7hRmP3B4sl+Rf
	6KbM9U0036C5R3F8Qg8KnWf4biSc7DU2l909a/ejL+dqCmNeJWn3psTOfij9kHi/HEvgP+0Uw5y
	JtdhOzUa5sUQ8dQrUaVrc6woR0eAI2w4IY6TIHQ5KV9454U80wFjAPa9yghqdF9Oq573jXqvxMg
	sPrdh9QhPVQPPYfXH4VwBi7vx0ivP6+NFzzZ00QX+46lb7x3ZpgnC8qAx3mrfKyH0ei7CJQ4dYu
	nPqgoDPEBZH6BeIHZd77npp51YfnOUUCo6BRWiYlPpZyjU1S8amqrqNkm1oeREWkfxctvOQqfLE
	mmqLEFbOqT7KqUhY3KzIdyDQo8GaI3Zj0KCzoOHFV81a180u/J4T+9ckHLD/L37p9XTFw0eDQI9
	NoEkZvmyLYDv1Lz6LCCzAA4O/m0mLa11sh1vha2IDdws9hNY7XDhn+MuVefzqJ5cj7Cqtd/wbnk
	+0/9fleSs3nY=
X-Received: by 2002:a05:693c:860a:10b0:35f:8c5d:5928 with SMTP id 5a478bee46e88-3857073f3c4mr2688255eec.30.1795176627592;
        Fri, 20 Nov 2026 04:10:27 -0800 (PST)
Received: from DESKTOP-7QP7L26 ([45.190.211.142])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-385667decc2sm7674429eec.9.2026.11.20.04.10.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 20 Nov 2026 04:10:27 -0800 (PST)
Date: Fri, 20 Nov 2026 09:10:24 -0300 (Hora oficial do Brasil)
From: dev12124 <joaoanandalima@gmail.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, vbabka@suse.cz, 
    hch@lst.de
Subject: Re: [RFC] mm: alloc__by: create a function for allocate pages in
 small microsseconds in boards no-MMU
In-Reply-To: <4ed0eeda-22bd-4489-ad18-d522b36d22be@kernel.org>
Message-ID: <79570fe0-ab04-7f65-de65-ac34b07334c4@gmail.com>
References: <1ee9b247-6758-c146-2d03-0acea98db33f@gmail.com> <4ed0eeda-22bd-4489-ad18-d522b36d22be@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
X-Rspam-User:
X-Rspamd-Queue-Id: 3627F80007
X-Stat-Signature: nf79x3m74dqru3a8exmu7i9imdkwfuy9
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-HE-Tag: 1795176629-389720
X-HE-Meta: U2FsdGVkX18We63W70Owg2Qw7oXmzinsKdpN5UXC2RgMbz39bEtkaLYHcnXPI2IH+W1bikhdj5TsDjaVg79qTf/aL3FgvR0G7ZykPMZPX9BLrL3Qodoxa+7bfoQDZgHu03sgljilao6HjRUh/dpG+ht1w6U3DylVGoxk7YCIIBDUYv/aPOiYQ82wKmaDvIgbU22xKkX2JeK66hjuXJDgKwxlHJ2sH5b9FgOPhKr/GH0MdhMdCc2HFXJa/ghNGKnD+l52kz631YH6Ihd1zMmB9yBpsRpxnX07b9m6L/SMdS8jnjlm2+yazEqTxAMj403WM4cjJa32hE1SyXRKlUIMnQRHFyHUNhYcBdjLRorFPmXOoM5o/1jQyJN3bPt9XKQATVdti98iIRJdfscznRYwW/cgNO/wn4109PLGtzB2LzPf1fTVJOI4ivVRoBqjMx8zzp2rTgkWNynjksv1nMEKaFCw4WOF4bTnb/dgLt+Yl5kVgAstV/AQAF1wJ2QHhKHF+BSWDjWI1ImYnnmkPqP8p/bXb6x+uYLssKxbDem8wgwj4MszdiQ978WxFQC2h7/5acFfZM4fn3no5cKV6ZpVoyttUiPghnstOyng3VlDP84Ot/Y3bL4/n5NeLOXKy6R+kcaCxqroCZ+RLAFzJkN/tuwCwbMA4mATAxaEJK7iH8a5qhO5XvItwAq8490deoUvKxhSA7UwFe0EEQbfk8UYvPULhLJ6Oa7gdCGSurmZ0GgEYBP7VzU0i29KSyopnf85hQcLw7+oCiHXr3yRzrm2UEfR1L8bQlSBfgNyrERTfcH0SsGdlse2ORzNVFqqjhE8xdk88AfGM7++bcVeO9fMZ3Yz3G3Bw8Cf0Iqfs9beFpPJSz2mWsVqSgtDMMcR3xEZBf6SC8IokPyoEReLD4bSfIVX57kvRZoI8iQ1CMY94zuYEGrlPrEFz4tpX+M6FdpZUEFJu15fGZSrAD3QUtw
 O6L8k5hv
 ZrgYN/Szu4mFn+02FzDp3ohGhu21ZI4Bf1rj7+9SqxEfbiLvx5RsyZavI6Goz4+X2+aWOxyplIBBl7NCWNq86U8+ygNQf6ecXCjWtVxThFnzpTkJU9VlGZTh0JhlK/UgjSF45fFNDT06bFMlEMuikQPuCdPiBqMKsuqfISrlDozNnQdPO2k8z+IfEYktAMa2tFGhE+xJN1FAS/lXlH3NUsDUpW/qXdb6un73BDv3rLwdJjZhHKaXgH3nszmnTq+DoSt7U3JqWLnJLxVwzoDaIdeRuzeSbhUgYQoxJuQSOrkKZiE/74vpgQSOIeDhP+UvZSQwU29kZhHb+PHagNKHAAmXcG8g53aB/tZ6WIJqIjEPKZviRiW+s97HrlrrzCZ2bVPy3vyqEBJnOvPBgNyYDaUfoWKQV4RdbIVkBM/U7nSDy8L2lb2hlnek49xuqspd0L5ShyeSHKarOLGV4C77E2MxU5xIj59rgbusL8MHVJBCiO8LzoCWRx6RIvXH65fHxbwlDuO+GSIosKIZ2JXxhm9unVed3iloctspqK57lwAB9LyPjU2FSzqxqtdnXphMikHo3Mphsn4O0qXRzTPBp3SGX5/FZM6P5OAAIDOxK9r/AI9L0aXDsmERCVOvK24cjMlBeQHm2wm/gfaGD/jCNhbaVvQ+ZUvmCmhKYswEA5Wk+7qrsNhKOrOv4vMNvrgVwNEI0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Fri, 20 Nov 2026, David Hildenbrand (Arm) wrote:
>
> Hi,
>
> I think we are much rather looking into removing NOMMU then optimizing it :)
>
> -- 
> Cheers,
>
> David
>

Hi,

Thanks! Ok for the atual focuos! :)


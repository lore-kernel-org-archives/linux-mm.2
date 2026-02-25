Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 037FDEFD238
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 09:43:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BBAF6B00C1; Wed, 25 Feb 2026 04:43:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 393836B00C9; Wed, 25 Feb 2026 04:43:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2679A6B00CB; Wed, 25 Feb 2026 04:43:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0EAB06B00C1
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 04:43:34 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id ACD1A140544
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 09:43:33 +0000 (UTC)
X-FDA: 84482491506.17.B320A82
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0446F8000D
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 09:43:30 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BSjE7YXh;
	spf=pass (imf02.hostedemail.com: domain of toke@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=toke@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772012611;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dJBC8mLDABEEc1VlJb5lfgoDrRuha1EpEiY4jlkAt8U=;
	b=RefZw9dQeM4ruj4oAxmLlkKe/VciDTehPwXzuRJOfRs1YIzS2C6Mhsq9Z86PdB1yUqaAxH
	m6JBavxbQQdZv7Zk31NyUAC9jhQW0Jvtig5S2PL82HFCH3Q5AUqIeLEEPpl80/gZC6zTkv
	ifm8Rr5Us1H6cMP75PtY+5Ux980O0n4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BSjE7YXh;
	spf=pass (imf02.hostedemail.com: domain of toke@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=toke@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772012611; a=rsa-sha256;
	cv=none;
	b=gbznoGyLDFJlXt2PBoRnT0LEAIyulq/I1zEJ4J5OoM2I9hkxhZvnNaSdCcREK8YbJAOEW/
	4jAmXNQZzwY7Qq5wr1dRQtiZU7d38tGd51p+lx6PaiIZxSuN540UCHfoFOIKSvD1DPH5QQ
	IFFpEuJNZrRyQzmyIqnb9ipIshzf3DU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772012610;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dJBC8mLDABEEc1VlJb5lfgoDrRuha1EpEiY4jlkAt8U=;
	b=BSjE7YXhUTHmAF8fWvxzw2Muw4ag9kFuImifmLbEmVLjGDmwI+gLZlYMbFF5Q8D1UHAoo4
	hm873NDmneXzW+2MnCPLHELtwFHQ7HEH780lEJq/iqAuNhVA1t3ObH5NSg4N+r+My6fOfA
	+ltxCvgnjrQXRqts/uFv+nQmnNAZONQ=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-433-gz6H_3o6MdGBEmove922BA-1; Wed, 25 Feb 2026 04:43:29 -0500
X-MC-Unique: gz6H_3o6MdGBEmove922BA-1
X-Mimecast-MFC-AGG-ID: gz6H_3o6MdGBEmove922BA_1772012608
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-43985826d05so1283205f8f.2
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 01:43:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772012608; x=1772617408;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=dJBC8mLDABEEc1VlJb5lfgoDrRuha1EpEiY4jlkAt8U=;
        b=KIz34cT7a0o39w7SAxsZ1Ex6IvOAw/4xOg34/ZH1Shl2jGjPeYpz4aMKw7mgL1jkNY
         i1wmPggyFLE0r5fBF1XLo8mrJV1U5BXBIQePg6ho279/8KCcSOLXWnP1cDriXRPkA70X
         Pgl7DNPm6lQN4wqig6d7+Yh+gl61E8fx38hSpfI064K2LSV3WJLgxbceDfo6aEv0IJRl
         SEPHl1elDJMR6TSZAHN8q9ARZ4rAkVRnH+nnaM8xKDIRL4FLQMyBsZA+Jkx8gH0Dtibj
         o/R7EGHKYjNyWkzlP0SLlMvJ5tf4GQUPhP3ysmJKhH8D8j9C+3nMEmS6AJB4jtbIt5Vn
         qxJg==
X-Forwarded-Encrypted: i=1; AJvYcCV5TlGjt+f6a1sMneUk+Y6Hz0njEemSkYezgw8Cw3oODewalYLbd218slLTAeaZPh4e/IeSRxY4Kg==@kvack.org
X-Gm-Message-State: AOJu0YxilQ6yYTcXbY+N7vXeVwq8Q9UE20gBak+OlIFwdgykbBRHxpzi
	Z6gg4QcKFb6Vbmwa5VPoZkHr6jeDqGdYrWA/RcLNrlJSpItDQTjavfR4QgAT6yVW4eh/aSKEqmi
	dzmOtIhDVGRfnNiIweQXDEdPwNcCnjkia4BlTJca+9Xyiy6NziJ7+
X-Gm-Gg: ATEYQzxxT8Ukjp67Rai9h/LGLEtoommXOgV6PFfkyrfdB8Km9KWjFk025Nf0bKoYzYC
	1YdotiV2/ZRsMjOHfObM6Fud5IO4r1KDfOEbZ1ngpznK1tDmJeZ/+7rsGBl+FiBvdqR4Xp9Olf1
	qIKD7IPdrZE1CXupY3AeihBuUMCsNz76Y+zW1BJ7fETrGvXwff0Phx39WlPfV18jlW4+yZWasiL
	XlkvDrcmUgA4YdR23j0gXTn9gYlqzGpEN96ASV+TYJWwEgXnHA8G6+SMBKsBHZTfHFa4batNctd
	cNNu0zlAOBRMXccC9A8L3a/MuFUyO1IHhmAUVzVQPEYgnKxtAH4g8BVbGmJg7Kr4sdbdTyQ8l32
	2OJSWSnnTFs1MonxZTQlWVNIuHnwPFPdc0h+fN0PO7EHG8tSm
X-Received: by 2002:a05:600c:8287:b0:480:3a71:92b2 with SMTP id 5b1f17b1804b1-483a95eab99mr223255755e9.26.1772012608022;
        Wed, 25 Feb 2026 01:43:28 -0800 (PST)
X-Received: by 2002:a05:600c:8287:b0:480:3a71:92b2 with SMTP id 5b1f17b1804b1-483a95eab99mr223255025e9.26.1772012607592;
        Wed, 25 Feb 2026 01:43:27 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk (alrua-x1.borgediget.toke.dk. [2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483bfb85c58sm8490385e9.9.2026.02.25.01.43.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Feb 2026 01:43:26 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
	id 7DC33516AE5; Wed, 25 Feb 2026 10:43:28 +0100 (CET)
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To: Byungchul Park <byungchul@sk.com>, netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 kernel_team@skhynix.com, harry.yoo@oracle.com, hawk@kernel.org,
 andrew+netdev@lunn.ch, david@kernel.org, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, ziy@nvidia.com,
 willy@infradead.org, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 asml.silence@gmail.com, axboe@kernel.dk, ncardwell@google.com,
 kuniyu@google.com, dsahern@kernel.org, almasrymina@google.com,
 sdf@fomichev.me, dw@davidwei.uk, ap420073@gmail.com, dtatulea@nvidia.com,
 shivajikant@google.com, io-uring@vger.kernel.org
Subject: Re: [RESEND PATCH net-next] netmem: remove the pp fields from net_iov
In-Reply-To: <20260224061424.11219-1-byungchul@sk.com>
References: <20260224061424.11219-1-byungchul@sk.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date: Wed, 25 Feb 2026 10:43:28 +0100
Message-ID: <87fr6pma4f.fsf@toke.dk>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: z5mejXehCIkaJYAGcZGFR9b-FVhi_JDWmuDFddt40hM_1772012608
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: kpwz4dno7m9dhxqoo15esj8zk66yhez8
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: 0446F8000D
X-HE-Tag: 1772012610-866459
X-HE-Meta: U2FsdGVkX18Yy92kJ7shatIU09N8IUtaZ52Rcgco0gCfFvOU8bRM8nCnAEkv5YdqDqzfXWyavb9nqRzWRVnf3Bc4QKj3PZtgVnK82LMmwQDC8ycQ6RIjkXnVte6WhmTX87+gTGI6P0JXA+l9q3UMfRDMOWaA/ByLkkU1WQzSBCalXIAZXoGd3AC2HNkIYbbYhGlNEz+fcbxCfG+CvvZ8R/Ch9V8Y0xWoFivIhmDj6n+ttqzHhAd8cwrDewNF3HylxCxp2nby7INg716CJyoMID/jN6fpAh85Zyjcv1VctCdLpz0GU8TzYsbfr24hVcuyMYEow5QgQTq6hrq3XPy1ou651u38+DjHGEabocstpIOdA6IDKwVkUTXJzo/YjNFiYY28ZdhsExYIyvinanxHkHEqoZzNDZnnBWLv6QU9bsWmxqRgrGvMWtG5rWMXU6kNKmOI9ICy+Ty3xpRzo/cuXHmRkBAuooApIMTOXNIsyqmsIsBLublSfWNYjOf/HqBQymTLZaCYOW3TkTsEmGCVBkOtOxFx6dmD3BrxLzQrRHZYsbVTjBaIv+qxt/qFeGOHfrAgoVgfWgLzeVhCjKZznNkZ2qlhFiCwCqHbHSPGtbhz3YPEJR+RfuUX5fVgDoAaPXQNY13D2ekIkPOoPux0/W7Hse++dFjPtiGzvO7ua5G7coBCtMLP1ASjPOfWG/a7arE0R1yYqyY9maoFmZez46Mn/Mv/F+N/JzzhMHRnQtYJaWa18kl7LZmfU+dVyJ9KsuLHTWmhKklo/8gCow5qYFRXOaTGvD7mpE3aLv8nCzaAFt+U6Ycj/97Lab3E7lzFRzyUAb7Acmb6NbphJVlSylndQDD25nSLThfRN94zwm7tKXy/bqCK9qxJUEHStfNkuTK7bdr83o0HhnsuiZvweeO+u1118FAmk0BZgeJkylvwzmSYWDxnHbmCZv3Sf1y/35BKWWfV5sHq8TbWN8A
 tsTZlB74
 uLyDtHVGwuDPPJ9KjENpbnUW/n0h23lcGvlfg3yc33fuOKurdqPmENg6hfJRr1aX7FtjkfMhCtzIhLauGN4VLCJOYBoLrY5hYkl559V5jBenV55YCU6eiQBglwQZmVj2PHDjtUbUomIgkyL7+oL5cXE/CsKvUS1DmZFvJuYeUK43wv9AjdPc0KpS3ZJZRpu8v/h8JQMI5I168nyjGCDObpByRmlt6kg0VhOp6kPB9unKZaliMvdHdTX0W2Ldn1CTuCWHhT9B/tnW63306PCW2Ztl3lExZToZC8hV/UqV9tEWHD6e+VCb9LXxiiIpVjr01mS8SjzW1dFaOfPTfosYN6BH0djmx/6lvB6whvQubrEub2k1CY8NUxLfcU3X7+jUpeJrE9cBUTndrVg6WCfC1a62poUp4+KVBm1pxklj9sLW0bjdh/RAky1FU7LAM9mTRMNKOfH8kMrLPnW2lueh0u+tJ486AhadUToUsZ7AyU+bpvvTxpgP8QQwSMwx8WaAbDSQNLdoObdN5kMQIUUdI/ZOnV4SWyRq215CMW28SEWKKYeAg/0J3zPQODzOHUykVIlKikgCa0Nc5yjtZQLCYnZopWvKzD8tXGLNKy7kPHFBrXW6Jh7rotPj4g/sc29DcFI/EhkjVhZ2c5Ek=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Byungchul Park <byungchul@sk.com> writes:

> Now that the pp fields in net_iov have no users, remove them from
> net_iov and clean up.
>
> Signed-off-by: Byungchul Park <byungchul@sk.com>

Reviewed-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADAC9CD6E7D
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 17:08:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 163766B0092; Fri,  5 Jun 2026 13:08:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EDB36B0093; Fri,  5 Jun 2026 13:08:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1E5E6B0095; Fri,  5 Jun 2026 13:08:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DD46D6B0092
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 13:08:13 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 780421C102B
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 17:08:13 +0000 (UTC)
X-FDA: 84846492066.27.5C425AB
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf15.hostedemail.com (Postfix) with ESMTP id 60F31A0013
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 17:08:11 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WFW4KG2h;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf15.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780679291;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2vsxAzTqRPri5YqWpxDSLNjMAVQac8InpcqQUhSIqXM=;
	b=DwnhIsLbnGP9Q049aqCBsj0HxHEREopTQNgVbIVBEN/K3xz2iprjPqF4xLofwjdSlcIPy6
	V2bG9Rd+3nxT7UVZVUINXc0wZHQIDibRQY3c0VlsMwd7YDegrhzz5DAtXef3TvEi3PqRgh
	wb50xxgQlJFznUgbyj+LN3Y9DkPon14=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WFW4KG2h;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf15.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780679291;
	b=RbTrVVEmRaCP/fIlC9AvV4PsS/1MbBQcBSzNKTdeuefXEeLX9HeZgEXoeDAI9xXeuhzBeQ
	ellcbsIRYOHdZyryDVSGtwaenQQDJaEdYj0PFBF5PigbZ3N/+axc3XNOy1/5bu/bD6XXSi
	21KQv2eQUp702Hwm8Bm0sVlDiDya+u8=
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-490be03d47bso18169465e9.0
        for <linux-mm@kvack.org>; Fri, 05 Jun 2026 10:08:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780679290; cv=none;
        d=google.com; s=arc-20240605;
        b=kB6aUUiEbDTu476PGHu/HxZ0Dzt0piw1zF+44dgDw1Src+k4d2V42D6RDfBWl/h15F
         dV6gyjLWP4GOBJaUnZQwx2HcsguPIaOpV/lmdOy0abzMdx1DnoNfkVaa/aBFojTr8M8p
         IK4rnRj7nbvUJQS3PE5QSb+fGqKdfryy/SUlwYqBX32KUF1koR5F7uE8vxkUCVYn3q6D
         P/n66zLf/1G9OmPNZB01doJdrxkKZGRNFkrXACnrFF1CkRdL/gmVf1EvTkJewTXbt0Z1
         DxVHrR/gNsGTpDObb2b2Qa/r6W4EnrwRNS52VK9SRruCqs060Weyd4jBKLMUXHD/7wgp
         joiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=2vsxAzTqRPri5YqWpxDSLNjMAVQac8InpcqQUhSIqXM=;
        fh=P65MgFOIhQmciVDsA9jpboIw5i4MghZ/mZgzuSOXW9c=;
        b=EU7jodhkgZrtW2WevtgvjLRBEp5pdF+/PYgkFvSKmHfa/Vph3WSDKH+jBKcmAZtqW+
         xhRyRqzK2MzwHEnNCgViMclj9kslEKlWjDrmtCOSYm+pSqd0lfVEcGoyQFkzl26h6Dtt
         VrndaNob5J2gNeOGZTFtQ0mTDPyTxa8+8/oR8z5lyCejbyskTblxFs7tBnE0JREhigY7
         7/UYLrWgMLeWetjCmhWquiBaWw6hPHNpV8k7+3jCYf3HBErvgC3B4D9i9eDgzhAwFl4C
         r0HV0D5f5J+72mElYBVpFpAV/DhauNahmjj29BOBTCThyk5GWHt9p9CutFy2woyDI54s
         Bxzw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780679290; x=1781284090; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2vsxAzTqRPri5YqWpxDSLNjMAVQac8InpcqQUhSIqXM=;
        b=WFW4KG2hUpTIQ+umlLu1pMvSHYQIS7dgKpE/d7xX5hr49d7UxcvdqsyzPuR+44r/b7
         BqrLv8XSZAtKZWLPdmMFC6gS6hpvA4nBDfvQo2+vi2U8fS3y2ndEvQhPa+L89Roh6tmH
         eUE2DJYw5CMvgTs2NyrKQeRNfu3/GS+zmRcMRWzaqoH0wPbfAUBYNWGwEsg37MBr9e7V
         NhIqC3PJF8oSgOkiAN8KvZWk3Tmxv9X8RD9Pky7az5X6zao4iiiHyN0zNiuWKGGZlJzb
         B8TVKKGJzptCvbzGmxQI/XTfCHx0WrRghlinLtqlS3A16ItjibORC+xqiZIch8kQtgKa
         YurA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780679290; x=1781284090;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2vsxAzTqRPri5YqWpxDSLNjMAVQac8InpcqQUhSIqXM=;
        b=QKn7vsPIbethQWcpW2GWEjaX0K43X3UBnXZoCdQb/FNIY3xzJum4MPCuIMVU9o4KjR
         NtXUYt4Vi3i0BDvhyxcr2qsPKMEGRtEwFyJVoqaEnEwU8htSTdfTY+47JC77zqbHQhwK
         xn7t65/jU2k9go+gfhMIsal+k7+OJG9ZykKStTvdjj6jvMWvY1oA2E0agSA3fhXmYo4P
         +7eCRvnU/s6XVhnGTPfEzmWkj9youEshegjn9M8p7mBGGddE8avpW0JbQ3EnboREpnNP
         K3VmY8rlRcUlUNmBtHEfgn9jlK8VkZD6ujCT+N3ARxA/mLQ2hhV2pnPxzyWLxbM0kF6O
         3NwQ==
X-Forwarded-Encrypted: i=1; AFNElJ//RCjgARCMkmm8WAXFQke3u8dyMzXwNx0tMThs5vUhVZMGBB854GE/m6ch/nGNI+tOSibUzN4lTw==@kvack.org
X-Gm-Message-State: AOJu0YzA2DFqumOU2+oM5FBOdwDRfIFj5Y94Yn5eqx/b/iVtLRjpZrGg
	ezur1rFR5I4wbV0xzRNoR37HxboPzMGpvnU12pKoxcCqEfkiNNy6H0upUoa1g7HqvG9hPavu7Kf
	5vSWyEPS/+54f8Mbwczf42/8Vt0witB0=
X-Gm-Gg: Acq92OGh/qTxoRgirsN5eum1RXeJj2UNgPsAZuE9c9WuAYd2/kDXavLPwQnR5WfGF7O
	aedvWOnnxIexJsDfe54Z4RAxTUoDlVXxQASv070XrEqyxpAJZGS2cOS5iogF9Q+m+KCDnqXWXIM
	Z1kfPmzBFWvZjl7yGnJ0V7oA3TxsaI1nm3QngCtaZBhlaDmUy0xdHSgivpseCnXdbIiX0sTYRKW
	P25NP8zNo678njtmW5UPEEjuV4bzNFkzWwn+aAy06mL8LzpikksAi3u02GaKltR5FHHw35Xf6+S
	UxVefVjXdJD/BG/rlB1BlVHn8kvah1yql2rsqOOZcNrbqXCxww==
X-Received: by 2002:a05:600c:5394:b0:490:bada:6b15 with SMTP id
 5b1f17b1804b1-490c25de6e3mr81448815e9.17.1780679289990; Fri, 05 Jun 2026
 10:08:09 -0700 (PDT)
MIME-Version: 1.0
References: <20260601113449.3464734-1-hch@lst.de> <20260601113449.3464734-3-hch@lst.de>
In-Reply-To: <20260601113449.3464734-3-hch@lst.de>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 5 Jun 2026 10:07:57 -0700
X-Gm-Features: AVVi8Cd62zdu_6zDnSCHJAwBrh_qG1gu1EralD6J7UfQslO-H8HIyMp0hrk5G44
Message-ID: <CAKEwX=PU8=U+eom+YvSMk5zFhNuT6MGFmP0QA1N_awjbkH1i8A@mail.gmail.com>
Subject: Re: [PATCH 2/8] mm: merge writeout into pageout
To: Christoph Hellwig <hch@lst.de>
Cc: baoquan.he@linux.dev, akpm@linux-foundation.org, chrisl@kernel.org, 
	usama.arif@linux.dev, kasong@tencent.com, shikemeng@huaweicloud.com, 
	youngjun.park@lge.com, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: qs6z3bzhpkm5fow57y6c5wmnbzfnj85f
X-Rspamd-Queue-Id: 60F31A0013
X-HE-Tag: 1780679291-878728
X-HE-Meta: U2FsdGVkX19ub8IomuRaTFVm7bLMimpXOE4zKKdMarmsLFk+SDGZDa5iCazbr/mG08PgP9xTlAVje15TbjyYHBLDgSZQ5SljmExlU3M2ysh44pbRJZFC/WSSZqYUKA9KzhwB76neTNFsKAiW9IWUMe8KiDLAIa5pMDCBQ1uHxFRK3JDXgWGrCp4pwERTXjTO9GeCdSz2g4h8CssZaVE3lW7HPIP7y3tYvrPL4GuwpcvXK8ZUuItLoVAic2ibzzN7kQfXcjrIoLF4TYpnO/GVZ3gyhwd5ZG2Cg1lycE5xTmw5JeSgRtg++h5lqWDCIYxXxUMuFEVV9H3MkHltukVIIeTG1rnx6Am5oBVkKXXUhzeRCNtFyjLZPexgcuQPRU2hQv4p/SSYe/Pj4pQ6hiF+lsMiPcJrMbJsBxEUGw9Fxt1OMd6l7Qj3JoLhd/Q8WlOthmMZ5YuL2O85lMUHr6GdAW+5U3dUwZFK7PMPKLDUEPGI/n8xuFmMGrnZiMzb8ZFRvz0KVw1shc0Niv1UPIITtoXaLlVomuGAX931nRjGu1GTE6DGk7c4aSoaYKX9oHfhT6jBBqYUVD/xSvTiuYpSt91DiiH7YgYvlBLRY/FMIm993Fx6+u5yjgDWPf+0cRg9sSFF+4yK5xEe8jAd3qqQ9m75oQ52zayyxAp+LggWFgUT+0RmZ0RtGcB1i+NZifwfWTdpEVvEXIpQI1ijbwvR5Da/t/REOzHBaTIgMCB2TtrhPQ4ATGdt+x8a0cTU1yZnXy0v85Z7zmF4G1mTj2votXxVfz/PVeVjV47I/gsNxJjH+8cs/5Rmo97y1s0aDUAgdIYAdDOu+TtSRKDX67UIkkK1HZqkJyM/9e/hxljpUJjTtza9uxLdmrLCzp314NcPg3ulKb9/mDrQzFq/3tgplSx5jHGOCKc/DycpeNVNobwBTP9RYys5/qg+K1FHOxjpiRcKwaS91MlwQqHeS1g
 hG4R/EMO
 JSV5x2Y6Yd0rVu3Bv3x2FbKgp/s5Tf6jnwAuc7vRuRztcNETjO7cDDFoV2wm15nzvsgwD1t2NkvvKvT5uj583Q8c5y2xP6yoGEXbCWFis5InSfCtMuZSFgZCNbRObydHbnDurUdg2OzCB0TLRwZZA+uIBOuDLqOg2JjltetLI4ZG8eXWUGKMjCrZ696s+OAQ7GphSqeUFwUxPccotHt3syWZzLKHRPEXg8mHEbCUMxf5Svxty9TIeqzBL+NjNGy1Q1US1OvVoCYvxMxhKbfXQ8OuQ4zlbkEVngbCZxVObImaYjlbz8L5Rmr3iRALY04Xr+J8yHeLi1onfA6u6St6E4ib8el56WyZRBEOPGOGP554NTCh7r5I9gSk3jVmPbDo9zZthOV5XJphLHRp9pipGGnsX6kbwYi5zg/zCmPSQHJoABU1WUnVkiS4CjBUbhaSF48TFUGJcV3KZoBE4bWW//pqcZohVJXmcnAESjAVwT4tTrXU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 1, 2026 at 4:35=E2=80=AFAM Christoph Hellwig <hch@lst.de> wrote=
:
>
> writeout is only called from pageout, and a straight flow at the end, so
> merge the two functions.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Nhat Pham <nphamcs@gmail.com>


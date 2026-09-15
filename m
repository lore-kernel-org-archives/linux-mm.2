Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD596C88E53
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 12:01:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED94E6B00A3; Tue, 15 Sep 2026 08:01:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8B0E6B00A4; Tue, 15 Sep 2026 08:01:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA2B86B00A5; Tue, 15 Sep 2026 08:01:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BBAC56B00A3
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 08:01:09 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0684E1403E9
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:01:09 +0000 (UTC)
X-FDA: 85215855858.24.0AD3989
Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	by imf08.hostedemail.com (Postfix) with ESMTP id C82AB16000D
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:01:06 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.s=20251104 header.b=uyFnex0B;
	spf=pass (imf08.hostedemail.com: domain of axboe@kernel.dk designates 74.125.225.76 as permitted sender) smtp.mailfrom=axboe@kernel.dk;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789473667;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WXnLznxt+LUzVKSpuZUKgVMVIlvhchloL5kq22Pk3QQ=;
	b=1C1sULSzwfGyf3vlL6HvwOmH8B0d9dBjNY+O5F1ZpykYoLqEpnPZWRXqB5q+QznEEnXqQ/
	hU9qhS53orirKQAKyM0wLurt+fmMXyZDxy6xxhIOvYYfzrWjPKP+2C9xU/IJRBImt0GpPr
	3NTFsvbyJoovXzDKs9QPtCDU/4zk0M8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.s=20251104 header.b=uyFnex0B;
	spf=pass (imf08.hostedemail.com: domain of axboe@kernel.dk designates 74.125.225.76 as permitted sender) smtp.mailfrom=axboe@kernel.dk;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789473667;
	b=vuSjv9gvjKXmMW6YLL8te7w3xlbm024qPKhWo5ycWft/vnULscIultnpbVqwC95ggJNbX2
	gceliOhzaK9VNcnG1C/hhHR58Ma49uEc0B7fLzN3mOz7ck5sNcz2f+p3ck4MwoPgj8WKBF
	RdNlEN7229JI89r1LB6RYid0e9La8PQ=
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-485ac898fa4so139211f8f.0
        for <linux-mm@kvack.org>; Tue, 15 Sep 2026 05:01:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1789473665; x=1790078465; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WXnLznxt+LUzVKSpuZUKgVMVIlvhchloL5kq22Pk3QQ=;
        b=uyFnex0BbipCnX3foR7Mi48eRS1ItORxOrgTwy/nCXaVBZDmGcOcZA/9k4w2FHg3G5
         Xzybs3X2TAP3ubYnrB5tkAKe3I6csNEweC1IU+wrvwpGCAjOESOyoa/Rs8gQ6BmjpERm
         9mp3LuF4hgLhWIZdtY3ubuhkwIQQJ2MQrxNyaJwW5HCs3nL5tVF79DnLk3ybKcege7Tk
         Iz/jmR5knZZ4JgKgG0vbp4LQN9ceDoJlyry8Vi6DPqx6uMohVbR3e210lYUz5ZG7qp7P
         2rINJAP+dxxMG0sf3Aq7bzPXHzsdnHT5g2BjEn/RYkhohWWZjMnWm7UBn/YbzRzQeFSy
         1HjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789473665; x=1790078465;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WXnLznxt+LUzVKSpuZUKgVMVIlvhchloL5kq22Pk3QQ=;
        b=QkDLDoadNTWR7q5Ib+AsOpN/fPMuzyWueLB+yvmdXG600VjxQQOX+qcoNEjyCubVv6
         pBnVj/GkwR1ymvoIC2KqVstAvNNPJQt6Lg8eGApaBkBwx0eL1bZ7VWiYQL25P8wCFxU1
         d7MvwXa86Ma0WmhELRUpQ3bX3PXWmbAVeTyXOn0qW2hO3QuJBC9PLiEnLb6XDz+Ulxg9
         qo85i4MRLk0CfrGLrxmue6e7wnCFX72uzvfNmaGT6dS/v9eMTzm4xNc53MtVX1XHvke0
         hvsyoA1CXZM5tysx9uI0GbzB2+N9Y4Bdf6PY5NYRmvTIytg/eC6GCNPEZtBfhzwYKdkp
         yxvg==
X-Forwarded-Encrypted: i=1; AKwUvBzwmvfyDl431sp34cgU2mGO49DgLZw+pjMH6ZjfsUa3EGRF/Tfu+hfevsmldmd8wnXr4RMljfBv6A==@kvack.org
X-Gm-Message-State: AFuF++mYsu3YWQidZNIVB85falcBX4rXCQ33L0nPBOGjsktxzS7nAXxI
	ZyBi+TK7otH4VBuxe92om7d2LdPrVZ6q63CuxfWMmJwlMd2dAB6gZXs36AuFxAAZg7I=
X-Gm-Gg: AYBFou3Y6pNT2ATnHAlr+FuOtcNd7BclyxXVgh/lJXq+RJHBHMHChYjdUwk3f1Rxvof
	lAUmmpGmt+Bjt+OZiISEwnagyGypf/s3D5KNzYi0dOt/xzZ9EpO+/tnV4/gy3S5CTsdh4zlf7iE
	UacKYMf8dNfoRBo+qRV//bZQhzXBx5zAxVyaPQS+jnkddiFu9p3olzMcdE8pduFLVmIND6POoHw
	gKZHCZO6P4y955z+W3LFX8EfDZukzqHgbjgL3B25vvgEV0qVPh4BLugXgBOv5h2i9NHZXhzqLAH
	0j7R5bf+bnXpgXvm3RUdwrL5bKQAFgllHELertdf6ougrXlKFr1xulX3gKd6gkNCydcHtbwnqva
	0mmTlkNP25LJxthexbds/Rtes0Oi2DtbqC2ofxCllS58+By7OoAUVyHU2Gq1krNNZhC2UcfzA8q
	J5aLNmXV5UtMM5+LAsR4qUdeP1WxSbi/++8X6J6FE/eZsdNQXXY3erMddtbfRELOARc3DRzmvK1
	PitpUvS0cuKulELUYr9H33PLPGe2P3X+0uO7Qznea5rhprb3GTSXdFiEAOL+W4QjfDZw2ZG7ybm
	ejVLL6sUElut2lSOJQS5D3YDlQ==
X-Received: by 2002:a05:6000:188b:b0:485:8bad:fb4a with SMTP id ffacd0b85a97d-4870a952919mr622437f8f.7.1789473664622;
        Tue, 15 Sep 2026 05:01:04 -0700 (PDT)
Received: from [10.160.16.196] (150.red-80-32-100.staticip.rima-tde.net. [80.32.100.150])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-486eb35bed0sm35665221f8f.32.2026.09.15.05.01.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Sep 2026 05:01:03 -0700 (PDT)
Message-ID: <b860e9a8-9a3d-4a4d-950d-69bec1792144@kernel.dk>
Date: Tue, 15 Sep 2026 06:01:02 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/6] coredump & signals: an impossible affair
To: Christian Brauner <brauner@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
 linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
 NeilBrown <neil@brown.name>, Ingo Molnar <mingo@redhat.com>,
 Peter Zijlstra <peterz@infradead.org>, linux-mm@kvack.org,
 io-uring@vger.kernel.org, stable@vger.kernel.org
References: <20260915-work-coredump-fixes-v1-0-f354ca41780c@kernel.org>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260915-work-coredump-fixes-v1-0-f354ca41780c@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C82AB16000D
X-Stat-Signature: muqr4ayjbckiu16sdz8nm9h9wgjmstzb
X-Rspam-User: 
X-HE-Tag: 1789473666-178930
X-HE-Meta: U2FsdGVkX1+0CgtivjgvZbL2le9jBWnBo1kWXCIc2d++eznA+FUEZzuMG9K7Z05Kw75kIRUVVPuXGknnPEfEA61lI2gb3O5cDOjW9veMECHrlfY0pimLUeIXJPz8vrtEbhvH77NtotxWOdUpBGSCrAgMks9zu2oABKq8U4KKNoo5U19lijzv9AK81AvrGSG4RP1dLM+kQqwBMQff77fMI3NmYm6wLkGmURk2gjwtmvxDUZsXhFEICnWzL4Hv3Z5feYJQIi3siHwm1FcUfUq5rkrVU7znMpZQ+aYo/9dWd4jTWCPDdQzG+TYL8SbLrOywOW9MFUhaXguu+h9M2G+/2LlRDi/dYl+HZskzRy3AEgj+pY/F8YcVKTboPYl/vrbm5zo4RM99I/La2L5VdwNLWaIOUh5lkmTons80nup+Fe4KEEKUYmM39VdGrXR3LyGE95D4AY1ZKnHoYob4Vf3JqQNksSrlc7wUqof6Z98vVXXqiazYNOfPb80soKdcVv7CTu++yr5lKL4WlAL2rn5rEN5PWEHmpvV9CYiZjsQBGRy8ambc9HXiYzmTHkCiCezwPZOq6Q1hcR6qp8IX9DfacVtx0Xa4qmA87YQ0yznPWIvgacoWiDGPpD35AFikWXw0PmWrEH4TJ6QoxnodZaJxCOR+6+GtYBOph/p7sQYmKQ9YqIsNNb1sIARRN1nvBLc2B+i96tKQmqsFjFPJlAVNklL45ZpfWJ+gtYgFfbQ4NBxjquGjDUUFa83v7t1pPzZRFBcLbCvuxXOmPiQYpWQPpBFMK3cBBOIp+HZ5ffnSwqg7/qKFHRNbbhbgAxKCtPS3S69oIS++Y/nOcy58/L92LYB4/XjM5WApSTtcVBXdGvudzJEoBollloT2dI1N8VVBDwk0fENoLpU3xq7OLEcbcEMQoqCXGDZs6QD1qXsPlO0VZN6ANrt7TzBmc9G7MOw1bqmNHyHUXNsGRAsxQdz
 fakcOKqv
 vZQx/z5IesXbGNxHW2EzQVJ0XyAJgB2cGUi0MNzwyzqUJdPzhRizcim8lVTusebEoHoYyih2Uhhj7Wwe0S/5N5VFKlneCu0qNU3hIKHA3+q57T3kLuFoM/wzXaLILFVFE7y50vaPLLkz/gX+3TdPIk+Ouc/uto5OnpjJYI1lXQwiTYA7/kgjhSAtFRusTYp7J4yC6qmtOo8CjosUuh92ibS3DOPgTuMeaSJFJDvIBllkUkBExsQPnYooHhgl3gOaDX4HdU2Z8St/N/PnGOTeIqAdsgBupeiZYBsPe4UKjn1Q8MQNkUo4wtdBpdbodq7mFvqJcOb4busDeSVQF9WTHZOeZXyKQzTplxIeaTistYdIQ0yYlTjaJp1Cd+2Qb7iF214Tm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/15/26 4:22 AM, Christian Brauner wrote:
> Hey,
> 
> I asked Chris (Mason) to look at some of the coredump code with kres and
> he found a couple of things. Some of them I had already found and fixed
> but there's some good stuff in here.
> 
> @Jens, please take a look whether the io_uring fix makes sense. That
> kres thing added some patches but I found them all not very good and so
> came up with other fixes mostly.

Both of them look fine to me, feel free to add:

Reviewed-by: Jens Axboe <axboe@kernel.dk>

if you want to carry them. Or let me know if you want me to grab them.

-- 
Jens Axboe



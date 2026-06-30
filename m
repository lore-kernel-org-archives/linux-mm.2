Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 548F8C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 13:08:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24E376B0095; Tue, 30 Jun 2026 09:08:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 225A26B00A8; Tue, 30 Jun 2026 09:08:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 116C86B00A9; Tue, 30 Jun 2026 09:08:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E07D26B0095
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 09:08:07 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6CC0F4037D
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 13:08:07 +0000 (UTC)
X-FDA: 84936607014.20.34FB385
Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	by imf24.hostedemail.com (Postfix) with ESMTP id 9EB94180012
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 13:08:05 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ltm9Ufqa;
	spf=pass (imf24.hostedemail.com: domain of igorpetindev@gmail.com designates 209.85.208.181 as permitted sender) smtp.mailfrom=igorpetindev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782824885;
	b=B7cu8lBcEg3mIk4HaKpR0sV2MTL6HF2hwlcBWjpS4YxZ2t28O9naI9YIIOQnZFmMMU3M49
	a6CK9MVxiaYrQpaLlExCl+4EX8rng05Y1AOPIZWFACDyytoyVDdEWYRsA37uVTCHKF9BOO
	qdE+4gVqf4TyksB+q3v30SjG3nK9P84=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782824885;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KY372+MQDnRqZEpTjqFttYs0FH8xWsPm7tex4XKhkec=;
	b=1xF1RAgwfca5km33V7nv7EKeKOeZrlPE36Zaws/YcKUUR+4tTeFJIIvJ3f2+7KBGn78XtX
	wGlZ8kMjqW67grZcLa2suwnh3Q13u77LBpryqa3RI3/xqpuJrLcCkoEgUjXhQ2XrYIwDLy
	793b5LYyNprfYsK9uJnKMJFtkg29Owc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ltm9Ufqa;
	spf=pass (imf24.hostedemail.com: domain of igorpetindev@gmail.com designates 209.85.208.181 as permitted sender) smtp.mailfrom=igorpetindev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-39b293079d1so1442691fa.3
        for <linux-mm@kvack.org>; Tue, 30 Jun 2026 06:08:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782824884; x=1783429684; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KY372+MQDnRqZEpTjqFttYs0FH8xWsPm7tex4XKhkec=;
        b=ltm9UfqaDh+15gIloCr/ChXxD0+u/TzL2YsCuYF06kpvlrDQJEr5k9Troy2QRDDaJW
         fgYjB0x8O0WDdu5YsOUz6z229VAq8TWdTosofeIEGWMjTCW9EbQU2T96CeekxHDaecmP
         GNVXk3Wxb3r6+fznC07Jghrzgs7uO5GqFNWhSo1ixnUzBkXDjNidCpS1sSvOwgguIVzW
         tRal3P4hIA7qKyTbRdanbdz+sAALijPAmkGT2XrcF0wknquVtukX1siA0cq/K12h6kBn
         m9+D74xlqlDBc61rC9Xb1XWPBJOrPNbjTLP7OP4tffHNNTfRnGOFogWMoliuCg2ngLCo
         FxTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782824884; x=1783429684;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KY372+MQDnRqZEpTjqFttYs0FH8xWsPm7tex4XKhkec=;
        b=L/89NVwIheXN7oJoUc2TaEtOMlZlEC/C48udblAoep+W0sbHaWNsZ208d1E193Qte6
         3XQprHLKRTwLDhbugxFvh2qHqqrI3enKYyrzhZ8xc6AkYC067lqX6pK+MiPmVCDOCefR
         a8G/rOBF1jPngvoK4EwOsXb6B1sDDPwncJWhnb9f1FvUC6D0BhtudR1JNvngfvqw+q46
         Q9F+jRHHexAHLsa9R2R5Txyz+qvggSZhh5L2RV7dNbGk0Y4GFi40kTBJcWWBQ+UUyA+J
         eJ7EMVgBL+IVl3LSDxBDiIg+NTeUy58hWck3ENa/PcVjMzbT5NHmCDaFMZe2gKOihiDV
         wB9w==
X-Forwarded-Encrypted: i=1; AHgh+Rolt0hTW5Uo4Pd4BUktVpFj/6sWP97L9GK5XIoObhvYu1x9Anafg+IJfJ/5OiZeGUTKCyoGEmj9eg==@kvack.org
X-Gm-Message-State: AOJu0YxfmBfPHW2qwnN5srbKmzHJp6vsyzlJ+AnnHHLGxlWXILn7npDI
	qHlsEeBvTAARfTbmjnup/GNiCl24hy3Tv2COXRquM18/o4DLzSzjADN/
X-Gm-Gg: AfdE7ck/F9PUgjQr9Z+9o3tYaNHgEXP+kq65xgsdm+FNPx0S+Bhu+CQsqET+84K38qh
	OrmBY07l19YQG3dVdmWXqNj7aOhEVqLztwZRLvlb2iMFFwuQPcvxcNkwoiUe1GSJ7FuoUcFWGPN
	NNAAVbB1VKp940x1vn1teBB+3ljA2BEpUAbYQtgZj92W8rT0EjjfTf73y1OGY4G0nbe7efWdDm+
	v6CU/cRkFd8pc3lbYS71VnsXMETF7FyLmro5IAJKNEwGXHS/ISxJYROX0pLH6y2jb7VRhj0bmW1
	Iwqsw0VpQtF2TFVe+my9q4r+WJx0X+Cux/1nPyq7BCn/9p19JkaQSJ2DxSXpvXDTaPyMB9ifC8v
	k5Sd678nIU8moDjguztrTDhvLdsAmQ4VIBGcKFednA7E2IqYt4NZU24DpLM2DljpqXPPCAqkSFS
	WNgvmaWWRqJj7QeZRzySXlNSeM5CdwqKeFSX/ONx74vMhm1cpcLp7/8yjEE4DoWdio/Gxq9wHiH
	8h8h2Nt66oi/jZ5bg==
X-Received: by 2002:a05:6512:3a8d:b0:5ae:bd66:553b with SMTP id 2adb3069b0e04-5aebdbca242mr916807e87.38.1782824883845;
        Tue, 30 Jun 2026 06:08:03 -0700 (PDT)
Received: from debian.localdomain (95-25-158-125.broadband.corbina.ru. [95.25.158.125])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-39b1da4d298sm5022501fa.30.2026.06.30.06.08.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 06:08:03 -0700 (PDT)
From: Igor Putko <igorpetindev@gmail.com>
To: 
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Igor Putko <igorpetindev@gmail.com>
Subject: Re: [PATCH] mm/damon/vaddr: remove redundant RCU lock
Date: Tue, 30 Jun 2026 16:07:43 +0300
Message-ID: <20260630130748.3908-1-igorpetindev@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260629165349.4260-1-igorpetindev@gmail.com>
References: <20260629165349.4260-1-igorpetindev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: qy5awu5xws3io4paebsftnygsix6qw5e
X-Rspamd-Queue-Id: 9EB94180012
X-Rspamd-Server: rspam06
X-HE-Tag: 1782824885-866536
X-HE-Meta: U2FsdGVkX199CTREekjPmallS9Z5dof0v5OxRZg7Fw4kiBzLHQlQaGwKhRESC98YPWcym3vYONm38yY5tLmopCbgEq6s6hSr0lsIkpyU8IsCZWJqgTQBk54+ex+suCbg9hBHQrOJpq+FO8XQhMqUVCdFwEUVS8h804OjbuC8k4bvOfGV3+UzaE0Ifric4NqoJW2lwfQUsnSD19r+Ue7Oi6zpKCTcGbG8ieEHOpge/06+hlVA2DtwsnRdekDVQiW8CHLs5YIYLICVxDUJlwIGOR/c7n3/Xr+/qgmHZ6/zU9RjMMnaYID6UxJ7bU+K5qHxs/ibOzUAqT4xB/bBevg8/v8ZmksoiSHHidXvbU3jfCIqcf3LK4DX4JLZtwwkqSMdgGA1gl3lE3c7oLSqN5vS/Vlx7QNWlGf3N7+bsGk628tXLASKhqK3Gz6LRI6mSUDi/42wyiy0hx63fooFhTOAI+h0BBu4U6xwZw57gQdoM1oFm1mwkuTho4Kn8oY3Y2LeeUWc+ONaxCFS4YzPzYLsDygJ8LibGk62fRAe5aaOZEzTIrkFDxArUTY2fPmjMwQcVXHB058yLt1MM9pmXF2g4V3IPxWLtrgV5L0guj3DhRiqmVS3v71h53v6eoQQvEq6p6nngftJuJYQ2q+RVKRd/SZGg4po5XFFVQn61YuZPQQw4BgjHTkdLBB/i/FxRB3p7bdSs4FDaCEbD5dRiDi3qrNQAVKYC1740wGZ82cD8N53kJf7KUYUdnOVOP5T3aiBNlJdeSvEXxb9LX1dHZtKg/bPJMgqBZWa9QWkHs3jEhLRgWQsisj+0JgLnV0ZbgcuFzVopSIasX3RspY2kvzESRf+zFXIKWyyl3KN/VXoy9lCAb+y/jtyEEz/OENMdx7f/DSnGxyFD8sL8pKe6cKq3hfgcNDQcyxbAsfJBW0Vtnb+wYwlHXwe8WyX5fYlpQOOpNYwQfyjnEt4ziYWo48
 W78wPuNu
 xFsH5JgRjlO25hSBanKZpNDAWFzK1z4cwKf9M1VNBrl3WrSgcnl0tTtz+/LV9X39nhUYS66G2bhSbL5KLFrQ8xn01Hteg7xCs9C/gWRHxMMep7Mqhmj+rmyyO1bp73cnRNUA60mFV9uHYMA2S6gDEfBTisKo9dWvX2i5BWpCYITV/T12/5AOFWCUTdHaRAgjqoT8gN6O2oGx7/053HQcmevC/t9WP8jfplvyjw1jT+tMfqIlsqOPxXLIqg4EqIzWu0UA78t9OOzebP3hVBxWf0RfMueb6ISSfTwO1ZvcmAOAWpiIOHKIkAIVv3gFSVhNYXRNivW6YZMnA5B2gpR8wnXrZpC/bdvhIJXUijiU1ab0CJI1ZSzTtetP5F/swIDXOglfy4AzsgAP5vY6hA0993FQl59EE6faT0YJPvgkf636+Xcl+IVW2Sn0+wn5xUUJpJ6HbWi4uAJnS7FQDV9hweyeyWRXi5wFvgeF6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SJ,

On Mon, 29 Jun 2026, SJ Park wrote:
> We prefer using a real name. I show you used 'Igor Putko' as your name before.
> Any reason to change the name?

Apologies for the confusion. I recently reinstalled my OS and misconfigured
my git setup. I will revert back to 'Igor Putko' for the v2 submission.

> As Sashiko also commented, this may cause lockdep warning. Actually this was
> added to fix it. Refer to the previous discussions [1] for more details.
> 
> How about moving rcu_read_[un]lock() to the caller test code?

That makes total sense. I will move the rcu_read_lock() and rcu_read_unlock()
calls directly into the KUnit test code in mm/damon/tests/vaddr-kunit.h to
prevent the lockdep splat.

Regarding the pre-existing high-severity issue reported by Sashiko AI about
missing check_stable_address_space(), I believe it is out of scope for this
particular cleanup and should be addressed in a separate, dedicated patch.

I have just sent the v2 patch out.

Thanks,
Igor


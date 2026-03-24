Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3B5DFEC119
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 21:24:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0316C6B0005; Tue, 24 Mar 2026 17:24:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 008EB6B0088; Tue, 24 Mar 2026 17:24:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E87F86B008A; Tue, 24 Mar 2026 17:24:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DA3936B0005
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 17:24:28 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9AC0358EC5
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 21:24:28 +0000 (UTC)
X-FDA: 84582235416.24.084005F
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	by imf28.hostedemail.com (Postfix) with ESMTP id 85909C000F
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 21:24:26 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=mm93eJde;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf28.hostedemail.com: domain of dmatlack@google.com designates 209.85.167.53 as permitted sender) smtp.mailfrom=dmatlack@google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774387466; a=rsa-sha256;
	cv=pass;
	b=dsnTYmMqncVVJ/tYifFvLFwl5EKAonDv20NdcuVL1/dt3lx/u7JotkdNHHoiqMyLoEo53P
	wqCa2CyhFNjQO2UbyVsA/hhon4wZTGD/sKDtxLb+3jI225H/zYqVSB9lvJkby7wI/bfysc
	WCUhBXkeppec7mHmBJycRu25tpV7JDE=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=mm93eJde;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf28.hostedemail.com: domain of dmatlack@google.com designates 209.85.167.53 as permitted sender) smtp.mailfrom=dmatlack@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774387466;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3Osyz4LMrl4grZpa6FE1mV1/7khBzvzZkRNFcmPzp30=;
	b=Hxe3SH88TE0RCQzzNLcw4OybY469AMQjdAHQ2I2eADriFN2N5hyHB6CFA/mkJv+ST8kIVd
	/rhab5ol4IWIwXrAEncFYvFpZnSr5VdFEt6DXS+QqF1c++LsbbGJTxPt7CbmW+XDy7oJw6
	tneL6CVvgkgZgFR97QD1SNmOLP2NHGA=
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-5a27c329e98so5678801e87.3
        for <linux-mm@kvack.org>; Tue, 24 Mar 2026 14:24:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774387465; cv=none;
        d=google.com; s=arc-20240605;
        b=k0iCILYCP87PWcmCnnOTn+XlPdCVNqgmYotK31j4Oopa9s03I4aiXnrxUfG5fGuKFa
         zJHZhECjF9nEly6p+BWOavML1zI1ggXTb4wSPiVQR3nseuz+maLHwDhxo6XxzOmRSvYZ
         ZS5E4FGPl6QjnDcUFRaoKR+jwMiev5A3YJ82/0wIIfN45gFFljfIUyUMWqox58g26uo8
         Q/81eiJSV5xgNsdBH12AJhTwGbQsSZsnMFIT7WmqFgqhnaeJbtntZKA/Qwf+ZljS2GOD
         fdIT5E7pjmlBmoSPUAyme6nOz4d3EAhG+ZUFkLmvSbzPiAkj5+2nxyPJBXYmDNER7rYb
         ZXyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=3Osyz4LMrl4grZpa6FE1mV1/7khBzvzZkRNFcmPzp30=;
        fh=P+kzz2rtJs8MwX3ClS1RZs9P/hT5Poj5QQARbWiYpYw=;
        b=ixO7dELPADR8spEUOzX2yw0o0qzx+yVgPWrsHiMJHBlGNyyK7zjJ/bgP+dcUDDUN5Y
         N2HC2PeWD/pQ+XvvHYhao++wvBpme7yo+h+ceYciR3QQ/0MYDR7aU/FNUk46bDgCfQ/E
         QHD6KV5m+5X/9lZ5qq5nat92Bq8yASS4REjCtdsyNCAAj156PdnXdnjt4kZw/dUIbtGs
         VRdTMiJ4qijcdiWg9niODgmUUkvNRy6DXdkmtdkfz2kXGpkg3DeEZ/1qFo2WB8HHu9W2
         grCX+JykI3TA7EzoxfgGFIoOJ3zLUAmfYZ6eoNcJRfwuIRApx6qDrjm+a6wigbs6jd1d
         ka4g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774387465; x=1774992265; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3Osyz4LMrl4grZpa6FE1mV1/7khBzvzZkRNFcmPzp30=;
        b=mm93eJdejHL6gIqOtz94d+1GhqB44SC+BtHC4WC1jf4Hj90BZwxeFY27YDRM4z5tba
         JZ+hLVedw4fdxqvQjg23MFD4QJj9Tfk51jnDm3V/FhGnve63/cMI1gMgmrJpnRYjCw77
         AUZNrPR60CgJntzxr1ax8ysdkCW6rl+kztqV+0tMkCNR1DLmki0sxW4sbN3mlkseKmo9
         XspRjNF6fhJuJLi7yvrxXMpZw8NvH7RxUFHHyjbuasQxCTnyMrm4acLVqOFqnlz2Pe96
         3+zRVvpOIjCs4NTPbVh06U4YVnXThVuGOPDbVTjPb022UY1K5RP/6ppj+LTxsJQVKrKF
         brtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774387465; x=1774992265;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3Osyz4LMrl4grZpa6FE1mV1/7khBzvzZkRNFcmPzp30=;
        b=cJzJT57x5BTwManqwRz3OhZfwVYtx/5+ougOQ49uu/K2WMXk2Twdc9BnZCRxdwUEhA
         ZumlSwAd+lA/JFuD1OHMp8pm+SCn9Czh4fMlS1RSmA/H043xi1dfZ9CHJ/5W/lfnZH3J
         8qlsAfu9wqpQChrYilI8RzjNiTkg1gX98zvdP1cNttm/TMTJWK/YTDyzoiq5GbGuHhcZ
         ClVoay7pW6Cqkhde6gaPexhvKWPPCk882gU7HlurPCQra0jzOfAsoFR/N6b4Ieg6ersd
         yPd0jP/2H0mv99l0pKkIU2wQkxSsL+pmkNP8ez7oK3Aq4Z4ZskA7FwHSOppO7kabBJZn
         lXwg==
X-Forwarded-Encrypted: i=1; AJvYcCXzqKS9PwrYecgFiuPxcehebDCDO5kkQa+BGfYmAdwqkT8vmK4RWsFQqQsqXZkZgSne3t/gT2iZoQ==@kvack.org
X-Gm-Message-State: AOJu0YyB4XNDl5AD2KZbJzK3p4UDPH2+Pud1mqdWAcS3fqgehekNGqM3
	cmrfdHy0gLUKT1zmqHmRPjFk/SJCx8CnpCXAIS7JS2hl25Rq86xlO58MLIcBYVpVfLj0isYQcWj
	h2ZJq1u7nCl/D8kNJz1bo2+IvOptnktfMaW29WBzf
X-Gm-Gg: ATEYQzzkojOrvXCsmjg0v4DmiDFWSVyD9gn9mTYdQJMVLfHRBIrlRKBnnyV/G6w+02p
	Om7+9v69Uh/8KWa6LHPAyd5n77L3jPrN/pIP2xUIhMt1A/DC1Xts9szIZ+QMvXf6oRPTfSA+KyJ
	SOaxcQfiDzhz+RzdwZAKRlE1WyEVyGI63hCuRWfVFXOwJcTz9CA9zNAfWyEb2UzuzBpJ6iahcrU
	B8KopORqhO00JaXBQnZdSBwwaCKap3tzOCINxfpxv9TT8pKV3ZDxR7zdOwWt7b+W5Jief4US7E2
	aFjquYC4
X-Received: by 2002:a05:6512:114e:b0:5a1:4c8:a632 with SMTP id
 2adb3069b0e04-5a29b976dacmr321914e87.13.1774387464172; Tue, 24 Mar 2026
 14:24:24 -0700 (PDT)
MIME-Version: 1.0
References: <20260318141637.1870220-10-pasha.tatashin@soleen.com> <20260318141637.1870220-13-pasha.tatashin@soleen.com>
In-Reply-To: <20260318141637.1870220-13-pasha.tatashin@soleen.com>
From: David Matlack <dmatlack@google.com>
Date: Tue, 24 Mar 2026 14:23:56 -0700
X-Gm-Features: AaiRm52LXcc-C8LfZJHz0X5TGe6ipMfQUWo9odKChlYP9O7L9GCYExr5BHUEcbU
Message-ID: <CALzav=fhwP1Wv9YjFTXoinX7R3rX-P0igvLbftBh+sZrL3dySg@mail.gmail.com>
Subject: Re: [PATCH v2 3/8] liveupdate: Remove file handler module refcounting
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: rppt@kernel.org, akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, pratyush@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 85909C000F
X-Stat-Signature: 6eg3qucs1buuokrxy1cja4ebumigzus4
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774387466-936307
X-HE-Meta: U2FsdGVkX1+e+Bpx+mTcddTSFSFmhptvTPPgPBdF2wrgQz4k1AKuX+8zseFq2HAG0JAxpwzalNNIdNbBHftSD9G8Cbj6RlUc7hE3xlBTsr9UUbb5O96o6GS0FTd28XoGTLyyGQe6MxT3Xd9GKCrG9bPCiH6y4uJR62F665VS9Y/NItu8/b7k5a1NKSothjoXZi7+tCx/MZy1++qKJnCf7+A0rg5BtAcZvRzn7jQEgmvXdFw2iX1ekHtE4d8QtMYsCBg/GKlTlJz/QT70dLRANPlf4GyLvmJdtXYHEyXMTfNVYkvt4KS5E2znojB7eZCv4EUpcremvDczI4urpcYotfQgXBNNhPqFbB4wptkdZRPnU8bHYdeBHPomEbmp5QWu2fsZE4KRcIdZnVcLThMgCNrAL1apRJcS/mYOyENKgSWUlOtoiiuDbs4ntmfM5m2Sx9E4IqG+uLisTTC8K5GZtv/etXTlBS4aC6ugEfv4EJ6BkjFyB45+Cf/HsptUw4aUkZcJ7U6Q913Kpwb1uohfB0gOIenbnLtb46Fbg1pcUlF2V4g0rN+wZoIOlDbzwfemmVVbB7NH8KYLKqKZoNePl8+3ZjBpA1IIRywS6Ks8m+eWQD0FMbnFPemYgY1UjtOW9FUq4FLMGaXxZ+q3i6Ni7nyRck/8cvRtF8IsC3BB7FwIoHCeSZo4fWMQOAzOECtyRcYPeuQgjrueNYXQepDVLPzvtSP5REc+Gtkh5tGZsXLLZ74+PCRrqzYVkfo/GCN5so/HCq49ST3Pkg/gtuxjW2J6YJElUdMUGoXK1avzBauXwg6oyNGBrMaSDtLsohslCsg2U73D5l/Xy8EQAN6LVaTuTiFVErhBRzEBwLlH7yvlIJuLQY0g+brb+44Z49+UyzQ5daqP/M8ZMEVEcA17y8HViATSmVn5AZ50cnSxQEokduNlX251yETgq4NvQQhtY3MG9X0FU1c250KS7tR
 GRfRDqdh
 wJCKI8z7nXgGy6MFMvLkkYoa1gxdEoVG7aESAyOGjEScQeUOME5xugHoMwAq856TJSAE8g3q04pz89gt9hSu4KNaTPa9qRJy3FCgoy554pB37YHhFUhqEFGkqMjDcXPSimjS1XyYyt/aKl5GD0QFa092XJnZ5CgojH+4ZEXYU/7smnEXPjysxvE5LLlhwnGzIlT2SjIbNHSqXUdW55In7HBafyhJAUrpskw6RTbqCBIn89/U9R08F3V+OvxXcf793J1xEHxx9d38Kdg0mWYFSWdA3VcExJJIGHMqqLuqfuIkfEFM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 18, 2026 at 7:17=E2=80=AFAM Pasha Tatashin
<pasha.tatashin@soleen.com> wrote:
>
> File handlers do not need to pin modules indefinitely or during active
> live update sessions. The VFS 'struct file' pins the file handler's modul=
e
> via f_op->owner during active sessions, making dynamic reference counting
> unnecessary for handlers.
>
> When a file is preserved, the live update core obtains a 'struct file'
> via fdget(). As long as the file is kept open within the live update
> session, the module is pinned by the VFS and cannot be unloaded.

After invoking the file handler's retrieve(), LUO should probably
check that the created file's owner matches the file handler's owner,
since this scheme relies on that being true.

If there is a mismatch, LUO can put the file that was just created,
log a warning, and return an error up to the user.


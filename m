Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4C68CD4F54
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 19:51:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D79476B00A7; Fri, 29 May 2026 15:51:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2A086B00A8; Fri, 29 May 2026 15:51:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C186D6B00A9; Fri, 29 May 2026 15:51:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B43376B00A7
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:51:45 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 44C3A1A0255
	for <linux-mm@kvack.org>; Fri, 29 May 2026 19:51:45 +0000 (UTC)
X-FDA: 84821502570.03.A08D460
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf07.hostedemail.com (Postfix) with ESMTP id 457C84000B
	for <linux-mm@kvack.org>; Fri, 29 May 2026 19:51:43 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Lp1IkwYg;
	spf=pass (imf07.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780084303;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vnofybMfKXc73Z7GzMMBieo9YudKdcjIw1E1DXfQBmE=;
	b=08bmS6DwMor7jFrgy1qeCTm3Vtb/Kr6uZxRd/Xb1On0iRxxlaAfm+G9wvF31L0G5K912+F
	xVlvk/sj0mbHaOXU5uQ7QzjSfZokeyc3ZjQy0gtOMxvPmFQ/uruukq8JhGWhty9PNq5P4w
	Eol96uRPXZhl7/2yLdBO5Udvrg+tBoA=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1780084303; a=rsa-sha256;
	cv=pass;
	b=1bVjZM+dkfbW6+g/AwSoXjPgq2eUJojSXua5UkMGb1IGfYtSaUm5lEA1KStXsH+cU/UvhB
	sLt4Rs6QLgjs3h8fBUEPBqiK8JkslGmP1H5+9bgWS4cWXsnQqtYxX+GHnxBOaHVtcq/dgq
	L902Tml6uw8jaIT/tVr+b3suPNMkVbg=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Lp1IkwYg;
	spf=pass (imf07.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4903f7a90d1so71588015e9.2
        for <linux-mm@kvack.org>; Fri, 29 May 2026 12:51:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780084302; cv=none;
        d=google.com; s=arc-20240605;
        b=NqcX3sePAqj3MpqbcLdglXFsfGDfJpvxy9uZpda2kc61KKANjxx5HmiEofbUc29dyQ
         bBfyDeWDJ4s1zh/fg0k3FAow9hlMxnnlEh3XaZ1s1Lw4BzXKugwzC1k7pMaXetoxFS+7
         pOBm5VR3VpidI/fyhWBbXe2T57vv7TaZ66zehDraE8gxSXQIekSBnbg2Yc9UIx+bxqFN
         8TDc3BWlwFh1NlZut5KrPOjLdd+zyB7zsg+xSGObe4XgkKgClm0COFNjCk50hAUBV3EV
         108xJ1fhuMN/PlRPM38S4Krpo/QPK9vpf8AOyjbcL/crm9JsFhf3O971xqV228yIFsJx
         17iA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=vnofybMfKXc73Z7GzMMBieo9YudKdcjIw1E1DXfQBmE=;
        fh=snHJ2EiUL8ejIqYzc4uyKb7h/q3ujshKlEfGf3SdfWE=;
        b=bPTadtVK9CQmFRp2iUNONFxh9bO9brTE6FC1mbNC9nRk5pj/emV5fUahuRgeYT8hef
         FhuQU+qHWl68dI7nLG5nb89docBZoZwwlHsf1pr7yB/8xSXZEzdY+f5UcaWmwagmMVfn
         pofSTCEpokgg7wPJNOCuCJYQqXI5mp/aFkoum7wT5fDkqxmmbB+9i4l03WiZhX00kj94
         ZhOrhSoDgTLrXXq+WctjKRzy3qgIiswwemZAia0c8D9o1DXzd51XJ2yJKrmGD6UCivyp
         dKSelGqkyNWghjiTAlvhfBnqdNAPEn6tT3WS6jOybTX30QYLFUeIf47kM81qapQ4OV1H
         MR6A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780084302; x=1780689102; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vnofybMfKXc73Z7GzMMBieo9YudKdcjIw1E1DXfQBmE=;
        b=Lp1IkwYgX+f0gxEgXWFBtc1dUcca0YTqI350pb5ici+n9JME2EoHRXxBxcASRwzZco
         fBpzrYO+P4DUxXI7YBQWCP8TV3aeQ3PId1M706PHsc3MyLQZoCF3Swc69eELd+zG7ykw
         oAVeOdfPQR1687iL8SGv2FvpvH0TdOHrUDLMLQtec0inPO2CawE/dCIOhyu8fYWIsgEt
         sWFniLML23KTsAJUvPVfmwUnifNdkcVSO2J3H8ZfHE8cHHJPxNg/FjaLl9pvwwpt1ZHW
         cpTPOBh2GO3ztWiw1FokaRCPctlV12CVODnMkbzHZQcTAnGEUZZqa7LsHR1w/M2YHQMD
         lNKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780084302; x=1780689102;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vnofybMfKXc73Z7GzMMBieo9YudKdcjIw1E1DXfQBmE=;
        b=K6HIWYVjdxFWlXuTSpgzigc3/SPPY5uD/KALMWI2VpHGAd7hSvchjPdQwhaquT9ucB
         hun0GDC+pdWUriZRhxH569hRnnIcS7bBVuR+FdWT6ZGIMU1/1AcE4vlz/UgdfHlAIhDy
         xuLHHd77E5Oet6Lf8f2i8pm1/HhAvUOftA2h/wzE5cYi6Q9sYKcBHa8MaZJ40VlwjhJ6
         Ulx3Td/kVpEp1qB64UdogRulZP8E8y6P7msAYb0YUzjSUwIXDB5BirvimtaWGZhqJk9q
         FMyqIYFz3/z3yEoiKJJ/Yx60ApkUZo8Hlr8DL/MteRnSYe3/Y4HjDvYqJlzQiy+Oc6GR
         moJA==
X-Forwarded-Encrypted: i=1; AFNElJ/SBduzFAflUNx6gA0FauioOMBSwHsvM58BWlGgMCQzi7LhL2lHQl7D99YNtcRdjkDiaEbh5Kp5VA==@kvack.org
X-Gm-Message-State: AOJu0YyM10GWcNNUwPwO8LappwmuVqqh0z0qCluxHoWiMqpw0dllCpjm
	HD9DumIJn9Gs0obQfnKvpKLxSP2DCDi9Iv8v6GRJspUdnUtNswMsqYm4OHyFlO++xgpDrQv0bH4
	ZKG288+h7TE/A81A8xhr6DuyifF/QSxI=
X-Gm-Gg: Acq92OGQJh8r/idI6rKY2Xw13oaGxpRHl4dK3EIlhXJn4EVyU8EoVyBa2QPfClupDUs
	vCg857trSshpjckgai4T76tsFNJijgtmAlJ0SsYtu3YXkdZSXW+jGbr/0aRtG8ziq+m2rY9dCL+
	B4QtSn827tDtQOheAHEW8ZqbI9XjpCyeJRjmLELgFipIUIGO1U8t4+tBhZZoAiabkrLWYurewDx
	pdKG1TPxVBqsukSiKbFBKEiIx29Naw1nSB5VdFudXTAYczx91S4VZGubEE43Rtu8SRxWUFog3Gm
	3leRxZD1HuvBaEXTNp2OWJ+hT+8lMrBWmhJu5cnjrVgvXIqQyovxHYec/uZX
X-Received: by 2002:a05:600c:4f53:b0:490:3b8b:6ba2 with SMTP id
 5b1f17b1804b1-490a290bbc9mr18998515e9.8.1780084301582; Fri, 29 May 2026
 12:51:41 -0700 (PDT)
MIME-Version: 1.0
References: <20260526114601.67041-1-jiahao.kernel@gmail.com> <20260526114601.67041-2-jiahao.kernel@gmail.com>
In-Reply-To: <20260526114601.67041-2-jiahao.kernel@gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 29 May 2026 12:51:30 -0700
X-Gm-Features: AVHnY4L7tgvKRX4kdfRx8qsBxz-QbD35FXrun4oqca1DzRXBvrMnNdcuSN4_ihs
Message-ID: <CAKEwX=NrL_t2BiA7i9D-jUdzkTu-pJDy++0uvxrysetMc8aRUw@mail.gmail.com>
Subject: Re: [PATCH v3 1/4] mm/zswap: Make shrink_worker writeback cursor per-memcg
To: Hao Jia <jiahao.kernel@gmail.com>
Cc: akpm@linux-foundation.org, tj@kernel.org, hannes@cmpxchg.org, 
	shakeel.butt@linux.dev, mhocko@kernel.org, yosry@kernel.org, mkoutny@suse.com, 
	chengming.zhou@linux.dev, muchun.song@linux.dev, roman.gushchin@linux.dev, 
	cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, Hao Jia <jiahao1@lixiang.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 457C84000B
X-Stat-Signature: zwgy1gmfqyrzydh6gbpka8tdt73uj8uo
X-Rspamd-Server: rspam06
X-HE-Tag: 1780084303-307969
X-HE-Meta: U2FsdGVkX1+HcXXTYBcorjJp3kuRhhsCsGbw+rFYvKrB3mQalcxoEX4l+6tIu69gjliEMqahtUaw//NW9cQAKFLKH/pHj3WS2ZXfOXgq94b8a2vL/c/fDaQmth4AKQBzKYhWpMyNtjAjnb7JGnZtar4NRvKtgqFNrMp+044rP7w2o3QRrNO7rJG6B+0qdP0eAqit/Il5N7v3AS0pGY3Kew8/VrX1gt+FzXJVbIbE4CSlbgGbPyjU7/IDMOVEnrpU50nwUfCCTYYvURhkz1cmvTCkFTWWyYk7EHT4Vi/82JBr0V456M/WClr7ifBrhj7iMzV/FC+EovIDFmYhAl5WUURV0tSsA/GkPP0QIV+pDpJxYBqgZVnmq6chRexVexDCPnHSyiguWU/X+sRDHiNs2HTBEfiuM9NqhcLt3klUP74sBKq+A6Skgwqxsmv0BXT42xyl8bclIQaycjrSpZ7LXP+UNP1Fpzdf0DtuXQsrgpZk9oYYaYhyZ51HiDzOOBsCJLSYMWX7Dsat0T/8IcsS4PBAEvMevBhSe93EbZhpR9dUYxifENcmy8w6cYNV/vhM0wb2WD1UKhoV9lQ0HJ+ZwKqNa2CWv5n/YTnTa2BKEcoxtuCJ+HVFD9X0J/pBXdHl1k//nLtilnZh9marlOIDTAflefCUbIHpR4KDLC40VEkgn8cMWIA3G4zwdY2nabTLaxtZTDw0mC0p8ntwSFHw1+mQEu4HrW5Y4OQr3KF84ekpOXlb7VcbjOprSyjTkrluZGvh0tMMQpZGykd6iqBqWRBdvwyLlXR8UVO1nhrj9/UB5dOybUvTcRhZuen7aOKJIsXJgBePIF8YEdLm/HOJ1DW4Obcjiqjw/KHgQ0otuXqM6E+TCAFG0I5zY3AxUiTmR0vVbQ89jKkkB5DR+LQs6FkBZas4fcGaaDGTfpnYijnJQ0NwIgOyGdH7KTKGUENrxko1zB2PcfeSc7uw664
 jOmjzakz
 TwVyq4h6IWyOgJJIu63shso4JPDMTOU6YOrKIJKADsoIPl+hiJf0wpLWzM7GaJb4P7lqNCbDflsAOum2lm+7GBMPDmIKEEyWr+aBY9LpWVo8yy2YOp+t5UDWJB2PK8+q90/iIKjcupipoeAMFFcofgRqpE4KLwQx2noZy2xzhSjv6odKhTTPzytIWX44D1vo5Y2CV3hx0PyzEIiuzI81BPhS2/j7jkOLy7+/9Cu+w26lS9zW7dlPYwn+hZry7EQs3GQaFoknIGgWsZxV3I5QHr9vPnCFrl0vp//Wx+oJ3pWWNYvZPdHpLJVAQ9OCiV2taY8qOpfGjyFSMTXUTpwNTEloDuZTx2378a/7ml1Toljwk+Za2swO06rHSJ5FeK4mXgIQklFSJgvH+C57f/dmGFxAoHfsSMFT4agItq4bBKWSBjbqm+DXVNADxumsjPKEJ46sogf8ABrpJx1apdHTFEhUfGfeZ94eSCCESeSB2VgpQlecAAR3WIcHL5934WWeN6X17kDkjEy8HPO8yuOGWaOOD6khEeFeoiMjqaBEmHt0oR28Z7ivTtzcg/B8QfiVNS1IgNJ66TTg5dB+JqgDtFyaBblf6r9sy9YSr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 26, 2026 at 4:46=E2=80=AFAM Hao Jia <jiahao.kernel@gmail.com> w=
rote:
>
> From: Hao Jia <jiahao1@lixiang.com>
>
> The zswap background writeback worker shrink_worker() uses a global
> cursor zswap_next_shrink, protected by zswap_shrink_lock, to round-robin
> across the online memcgs under root_mem_cgroup.
>
> Proactive writeback also wants a similar per-memcg cursor that is
> scoped to the specified memcg, so that repeated invocations against
> the same memcg make forward progress across its descendant memcgs
> instead of restarting from the first child memcg each time.
>
> Naturally, group the cursor and its protecting spinlock into a
> zswap_wb_iter struct, and make it a member of struct mem_cgroup to
> realize per-memcg cursor management. Accordingly, shrink_worker() now
> uses the lock and cursor in root_mem_cgroup->zswap_wb_iter.
>
> Because the cursor is now per-memcg, the offline cleanup must visit
> every ancestor that could be holding a reference to the dying memcg.
> Factor out __zswap_memcg_offline_cleanup() and walk from dead_memcg up
> to the root.
>
> No functional change intended for shrink_worker().

LGTM, if the memcg maintainers are happy with the overhead.

Reviewed-by: Nhat Pham <nphamcs@gmail.com>


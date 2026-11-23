Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C74A606A31F
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 17:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=E+uX3Vmw
Received: by kanga.kvack.org (Postfix)
	id 26A256B05B0; Mon, 23 Nov 2026 12:37:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21A966B05C5; Mon, 23 Nov 2026 12:37:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 109D66B05C6; Mon, 23 Nov 2026 12:37:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E63466B05B0
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 12:37:25 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7E10C160963
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 17:37:25 +0000 (UTC)
X-FDA: 85467090450.20.DE0CAA9
Received: from mail-dy2-f8.google.com (mail-dy2-f8.google.com [74.125.229.8])
	by imf05.hostedemail.com (Postfix) with ESMTP id 8743A100008
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 17:37:23 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=E+uX3Vmw;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.229.8 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795455443;
	b=HSJOf2zQlgtnsbJkvLYrA23qjw7xCl07mgT3kTN/fhWxo0OSYZWAm/atpAXK3lQkF4mvyk
	Sn0H6mR/HRe37I3VxCKVupXypiCK2OywzEhnFcGPGQ5qZVcHBCRcp5nSDVgEp42lHPA/e+
	Hf1zYv1rsnOl/Plt2RItHGEXhPUgoyg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795455443;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K9/G9Kxx1sGa+ECLvFARdPS+xdwTBfsM5TBrwJfCIRE=;
	b=BtwSVbYWn1Vx9D0suEME0uR2uVnR8XhPXdZ3GwVU+4Co5qyZQat+xyhtN1zj5u8vIzCPCe
	/LYG8vM7FlWSYPKEM30T0XheRcuYJicPPcJS82g3mmq35JbZN/rpSp3Nyf1ngKXo7SnHPD
	vvA5KtBGJ+DlEw+ywkD68pB16oZ3Nro=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=E+uX3Vmw;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.229.8 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
Received: by mail-dy2-f8.google.com with SMTP id 5a478bee46e88-3831d564bcfso1418992eec.1
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:37:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795455442; x=1796060242; darn=kvack.org;
        h=references:in-reply-to:cc:to:message-id:date:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=K9/G9Kxx1sGa+ECLvFARdPS+xdwTBfsM5TBrwJfCIRE=;
        b=E+uX3Vmwbvis3U+VflhAfnHHQIsbKDlzsPQK6ilEbF1war6rD6xzb7EzryEAB8A9Sa
         w8o1EZz0K48P3/GvVJYnrwPSzJ3dYI7Ka+JK54keZ+M03FGH5oiOW2ut9dDJCcIuSZ0f
         5ki9u/4NBsrgEE/GWFvQA0zOFyJEpujOnqP/z38xoy7NHcgrtOtwbk1angmSXbHRV7v9
         E+x/W9lvbv7SRY3KlwZ8l9bI/uFTQaQ8lIoo6M755jq4MsyCCYt+oAe56QpqGkYSnh/D
         WujNU14Mv7bfo10wAN9A0j1aSu9knr4bgJQHw97ZzJ/9517OsBsdAV0Byz26TXkKYPE3
         oj6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795455442; x=1796060242;
        h=references:in-reply-to:cc:to:message-id:date:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=K9/G9Kxx1sGa+ECLvFARdPS+xdwTBfsM5TBrwJfCIRE=;
        b=a3I8DSnm/ofpP3y3eoQmNODduTB+JxUVczY3Xnl1L/eBKjMHJQlkfZFd48GibqVJdn
         se41zGbCdJbdUkfp7g4jyt9jDrZ+D80wa5VYz/mmHzW8rRHsFVwvdHXWS50TKsMPtZzh
         D6mq3WJnVLhZvU9ZYWU5yRhQLPJUG440Xmrtl44/XY0Wx8lTgkRqP9RKkKnsRPEH5SsC
         zwckVaOUirBdPEoyWgZ3IRPyEWsOFlgrkeMBuz6Ni9U2+KfdsQdjdLwiRsH2CPEs0tEw
         p7dGjxzXRD4ovOl8p6xo8LTkMOXe8yzWv16+MXVRPtgr+Q9xMR3D2SoibJhACQuMFcXL
         bKHw==
X-Forwarded-Encrypted: i=1; AL+hErHOpUYb26Fb/gx+zNk4+AlTFqR8JjaXOi0Uz2PhvTxB5ZkhRSMkhV8JzFmnvK6xzWlUgxiX4+29VQ==@kvack.org
X-Gm-Message-State: APuU4Z9ZYyf7FzK5xm965MEDVpZEYYnk9k9Y2aY3s09lZsqCmWns3V8g
	zUrxHTWfWEYF5ELsG6rL9H3JiwhzbWOf1L3FYI4S/+3e+7sg/dQOgN/M
X-Gm-Gg: AZFdTZfgJLIV0hON7kOCM9UfE0YttCkHJJdv/2m8o0e9s9TB583MfV9Irbi1gl0+0qd
	LNSgdYY5Xv5kos3H8EM4OqRcB3a+MVQl5lX2t0dMUAu33n1BYOqQfaLIRnIwdVcUksiI5r23UwY
	F1dhvxLm6D9iYzBJL/iBC3+Htp1O5+7xnLIburZ3S1J7/WCyvczkPolMJeGGW3fWMhKl73Ymvte
	PPefjIlHex279GMoT022uEnOqLV90IrhWpbZWlaLf+Fs+WDSFjn2tKA6D6l9YsrEtOb22Cu/zFw
	1r/loiEidAeHaG/l9lhneZWSlw3LJ6CJPFnLkmyRvazQfD57H+xb52PGbRIMq9COO8GwxTEgc8L
	g5Qg1bg2QJ2WY4ycanB+kFQgxVTlm+GcSX6ZQmwlS9MzaBEUPjQRHCloQJoYAnaR95uA5u4/JIW
	xpFGTVKMFCA3FNaaVLIL4fAsEKCNXHtPWf2fJ8UXdclt7GrV7J2yG4eWZiQw2jawkiM3ZHfMF1C
	b8tENr6Oil3GdASGUEAQpzuzNJ5tOlvT0S1r6DFXzZVML4REKyuEC4kDxpXEGZ4dWQf3EicpfQH
	mxl6WTnBAw2UmGW5GC2AnxacTw3oxjxrWBU52svTS9CyzVGQx1XI/6s+ACHKk9ELLorm0DvgdX0
	5Jjz2P5RclslZzMy8mcPqStGQVQBYZ3+OIFdXCSoaMlS9I8J3wNgCgE98yg10zQ==
X-Received: by 2002:a05:693c:60cd:b0:386:98d9:d5cd with SMTP id 5a478bee46e88-38698d9d928mr10456445eec.39.1795455442078;
        Mon, 23 Nov 2026 09:37:22 -0800 (PST)
Received: from localhost (n106-71-19-159.sun21.vic.optusnet.com.au. [106.71.19.159])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-38567abb870sm31532302eec.25.2026.11.23.09.37.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 09:37:21 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 15/27] mm/damon/sysfs: add filter_report_type file
 under probe filter directory
From: Aveline Noir <jm5905938@gmail.com>
Date: Tue, 24 Nov 2026 03:49:25 +1100
Message-Id: <179545256500.4.8792375728766851430.b4-reply@b4>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, damon@lists.linux.dev, 
 Lian Wang <lianux.mm@gmail.com>, linux-mm@kvack.org
In-Reply-To: <20261121210013.130397-16-sj@kernel.org>
References: <20261121210013.130397-1-sj@kernel.org>
 <20261121210013.130397-16-sj@kernel.org>
X-Mailer: b4 0.16.0
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: 9cd437peexq43nsr6t7ukdt4ditdezrz
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8743A100008
X-Rspam-User:
X-HE-Tag: 1795455443-933185
X-HE-Meta: U2FsdGVkX19n75EZk313ahUGPqaxEcGV2odzkdboTFYHYoTfHclsxgpPJd4c4l9LgROaHFFY+CaydPPK9C/dsC66fKTwhEymPx5XKAu5ASnuIki4hx4LSlYfy4hMHXZ2jp9PolHJdbEPWBUrzSN/nMQ+32ZajtFPzw9NR4Vblu+vlsMwUc6my5vUkkjdjgfOQCY5XJ00VJDJ9GUDxzmDptu0Ed1uok06JjK5Y8f2QxCV8MlKQLsoCd2gMJzvxAGcWUsMCjL0o8jkAtu5loDLNlfXKLPqy8Ud+zrqowRHpeeF7SgLyDbe1MalVRahNJbZaYsxNP4AGkEREoWrTAIoCXW0S70rehX47QKwLEcsMXj9pwnCXb6DsYzbm+jsmvwc2dKj2Wg1orhYiQzuT3/JbwTbOi54BSIxm4eAunBGMOgltlY6L1JCrrfFBL8s73qL7u0fPVy7U71MNdEZkG9OSJh+WJIIb1QwBqjstwgltbgX6Msv0C2PEZJqKyme4sa6D6mNUuSMreLivHlvHkCpk2Reu1XCFTacJ3Gkqvc0OigmI2X7hSyVd4IkrU08m3vBWGmlulLLtEQy+SaVOgpl/YKNnVHIZUZWn9CiM6TjvuwkeSw0/lxck4JczD2UjJrM3P+9ftQwLYVO2+4cWh4WgnaJ8qyVA3BYu9zuSAh+YOHadbpEHvLAUzejlUV/8nB8YQgpuX+igKEd3jGXiL+stQ0VZetX9pM1I0ZyKjnKORDBS3BZ0IGQq8N8eXOoCo+TOxtlFL4G/AcVWwCl6UMAnbU5QbyXVclROGT/duP39W5j4vewGBEG80wo4s2wakcF772lTIa+K7dVoDDEeZO1E2iU1JRVn6zRH+Wy3frDO4Gz6CY2XFLwMyFvGRYi+k1DuH16mf64vul6TAxQeKB6nBf3Xre4NWXD/DLQnKIqNhLqo+eLmX4xR9jT0/WDM/fn2d4Accy5krmWW4XBHOM
 +imd/HWH
 1LFliEHnK+h+Yd8++6nGO7Vl41n7V4nDVoyEDy/WPGv0lGN1Y5pFjwuPd7Z58ONAI2pbynbLSiqZ9+thQZ4kYKGGUB15hB47f9w5gsY96pXLIG4Ingjdm9M/mHwyyPdC8Vko1CRWoMmdarQAfbbmQH4fn317XCvY1qXmgNH2GFasabWIOAg07wekj4eOQk+OvM2z4b3fZUurww5pQTgHkUg7wgY9Uy4JYNV98AJ562drli70/kIuxoFqSL1+B07WUWGOilKJklWV5BartXLkIZLpMzgG2tFSXBAT95drSgrzGIh5PwTczaZTx1mwFuNs4pz60LT1ySwMjbOFrdm4d5f31vzJ4Lj4rGQKfQfjHK4jhCCDHOLgmq+rClpfgOw0Ua1MXCmBh1UE1lUFZo/4Sv3xX3lC0hE7cg16vqz5RptB69eAiBDt38dMVvdiZ24KZ9PbqIf6d6EMzRnrZNPySQlLOKLuOe4yKMR/3NhM2Kk8I/omniuRr8ysk+6Cz/VgEf/af1G+eV9CQQk/nDO0ArtjmbZ5T6FNyvDNwQMug+X4V296mm3lKP8m+A3hESBpkI1XV8EMIhfvnRSo1ozds8Q7UV8cWBBO22ARR5+zvZWeWvUbY4Szgqtap/qmmvFRqOtK7sUlQ2/pmZm27mCRHun8FV28VTvDT3NCQionR0i/91lyn1gXol0lSXcZy8rpD8AKQP8yhMnok3NkV9s1cNMOXqe21qKbrK5mPbVB/lgX2UJGuDsuy+xVeOOPzWjgneLQDrDo7R4UI/q+lGGdUTJ+zbJhLUGZmRTbK4LO6Zvi4qlk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi SJ,

On Sat, 21 Nov 2026 12:59:59 -0800 SJ Park wrote:

> Add a sysfs file, filter_report_type, under probe filter directory.  It
> receives damon_report_type from the user.  Reuse
> damon_sysfs_report_type_name struct for user keyword matching.  Move the
> definition instead of forward declaration, as the code change is small
> enough at this stage.

LGTM, thanks.

Reviewed-by: Aveline Noir <jm5905938@gmail.com>

Thanks,
Aveline Noir


Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E7E6606A320
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 16:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=rbtULbHm
Received: by kanga.kvack.org (Postfix)
	id 2512F6B05B2; Sun, 22 Nov 2026 11:29:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 201D56B05B4; Sun, 22 Nov 2026 11:29:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1182C6B05B3; Sun, 22 Nov 2026 11:29:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D72696B05B0
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 11:29:03 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 52B68C0725
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 16:29:03 +0000 (UTC)
X-FDA: 85463289366.26.0E08AA0
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	by imf16.hostedemail.com (Postfix) with ESMTP id 7F5D5180002
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 16:29:01 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=rbtULbHm;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of lylin1023@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=lylin1023@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795364941;
	b=56HmU78uc4Qx28QlTpcfDhDqIXDWION8KuuZDMMKFyW37TyjZzpI4xTIYO+j/CTXDb/ThU
	dG2EmPx2i4oKl8VA1juiVb1XDvF4EAv+x5bO884T8/KUWC2q1RHvGuiLy6AyB1Rfk1GVRS
	KBVmI5hvFW9eMk4QDOAQe09SM4mp+uA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795364941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u54RhPh31KUc6Mfc10ElYw3foIWIoI4CAHG9i2sGAtg=;
	b=MTdpt/IzS1cBVpQXlkSqOrdiGkkhlJenm04rAM/wNE+gziyGG+kSrcnPEYw26J5U5rkyrA
	aQShaGxlX7gBauKQN8ZlVHSbgnFjWuUDK4g/n9MBEUzgH/dy+0uu8NFuzhjF9I3R4PPUlu
	ybCfmClGN6JRlhFN1xrjSH5U2HrCfmo=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=rbtULbHm;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of lylin1023@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=lylin1023@gmail.com
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-8b32bc605d9so1137621b3a.2
        for <linux-mm@kvack.org>; Sun, 22 Nov 2026 08:29:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795364940; x=1795969740; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=u54RhPh31KUc6Mfc10ElYw3foIWIoI4CAHG9i2sGAtg=;
        b=rbtULbHmkOdi1Eg+9vBsYc3G6kMi18GLXvPZ7vazgythFAnWFDg4/d2L/0XZW7D5pJ
         VaG35Xtpg177M9kJ+xdyz9S0Gri7ioZnhrKHI8jFNTn51m7b+KsD/57BUcq5nNxnS6EX
         1BkerUuyiezeC1NZhbE/Hea+qNRmbXv9GTe7Zb3NMYjj5jAGt1mmfcTfT3ziBAx0Avt8
         Qo97eFSGEqPqGQ7aYTh4DgOCZNVp269ZYeaW07Cg59sfXG+52LhHMlJR5XD3BEZ3O9qB
         b0R4NeG3yzVkwUCbRg4wCWxK+z5607YjdoLbQeuntsNz08me53SGtjesTqjEzJKU9+Iy
         KvXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795364940; x=1795969740;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=u54RhPh31KUc6Mfc10ElYw3foIWIoI4CAHG9i2sGAtg=;
        b=mGCtw+XFZDe84dxWUNlqJX7zPxsH8HYTyOB2Lz8dk2TS/672GEeaCi0oW9+kFn8s7V
         lQ8D6Qk2HhUz3F80x+LcpeF/b45mCsQpK8oenUlxKjELm2+piKxBs+H7vvY2LMFjvsvm
         7EwV4CjcmOnvcDtqdhWtg5VByG8RN9r+Az1yaAwrcIK7vPs6Ki6PLmQQ+IxhvlXj+RzQ
         tN5iUk1JfntTOJ/dWOgKpGJ25HtPxhvaRn7Hkgw5SE10VWpVvL7rDzgseHI9w6nPZkzO
         Q8En9G3wJVPl0woQteD9W3HDZqu/BiM8IrzykOdHjhOpmzvUulXX2AMtpqorQkKLLgS/
         8lDg==
X-Forwarded-Encrypted: i=1; AL+hErEEWvUOMbaHPxIYieGOxGVIhgaLGPYkrDnPFqWU7NhT2ZMTtKakSFlpQRtwDSx46noMm1WMG3Gs1A==@kvack.org
X-Gm-Message-State: APuU4Z+BcmBexeOYmzRbbJw+calrAp2TPSHoVbw/JCmmGXFjQVVeVF+v
	/8GmdSgfBIip2kC5ZLHtosYGTxQIyIN4HPl1fw7MtT2LqF5tTw5UjEHN
X-Gm-Gg: AZFdTZexGCA+nzkeZ5GDAZzPBO70MmV5uay/AC2s+CZbBiv41Yj68OGDWeNlKb4OU7M
	cBWrO6XlGdUdzGIkyf2dZ98TI/0ulNOADwQFAAufV46tEmRHpYqL+BQVuZLu/vCGOUf4Jy5Liqi
	2wzt6kLpdGKMR3Egs5sg8yTTRbv3mNJ1j8IgCr4B5K1jIorwlYrGVhd+0/pYVw9edkM+0brOpl5
	8g9ASY6Pnr/33TXXbnoKOCszD4HOUXN/uz9CWIrFyjIc2GpUOquSkJCHheqT9n68UxxJril/SiI
	eLsEifjmbFp2hZfJZtBv5xvuI/qMf5CXz5KqqZWBWQs2+n6BenpX2hDRH9ACunFefMR9oIlPvkS
	w92ljQGLS8MQIsVicQlboo4t9sdNNqXuLr+a3PRORp5X9P3k7uexC3AAaw24tCpdu5Q9mbPnO/Q
	yNSEhKtXsn4yAP6Fifb6+ljCqkuOxskEfCOLcr2FXnhcFINH9jgI61d/uPznrZSdJ1VAuEhg/sn
	Z94DanA9rWnCb8mgAkYAUf+UknN4QgQDHBzS2fGfF5BVl0BuGH80mY+rkc88aRK4JlX88ALhTZ0
	EMVDc8u5dOrZTsoekx1FQuZLW9IppmRy2Zffl2GlWPhz2ZQDEqC+MpFqTQihCe36rrPsueY=
X-Received: by 2002:a05:6a00:3ccf:b0:89f:feb6:5d5d with SMTP id d2e1a72fcca58-8c87c95b6b8mr8202972b3a.33.1795364940056;
        Sun, 22 Nov 2026 08:29:00 -0800 (PST)
Received: from localhost (218-35-178-218.cm.dynamic.apol.com.tw. [218.35.178.218])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8c8706844a0sm4219437b3a.1.2026.11.22.08.28.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Nov 2026 08:28:59 -0800 (PST)
From: Kurt Lin <lylin1023@gmail.com>
To: Sasha Levin <sashal@kernel.org>,
	Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests: cgroup: fall back to an unlinked file without O_TMPFILE
Date: Mon, 23 Nov 2026 00:28:17 +0800
Message-ID: <20261122162817.2012387-1-lylin1023@gmail.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261105011824.1143947-1-sashal@kernel.org>
References: <20261105011824.1143947-1-sashal@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 7F5D5180002
X-Stat-Signature: 8o96iw5qkopzum67eqmrei9z8yh7djq8
X-HE-Tag: 1795364941-183446
X-HE-Meta: U2FsdGVkX1/dpfDfqWJnEXwWuuu9uvJCeq4x5mPxw/PJhNMpu5YdXf4HohAIyYnAiJmtJlYrLDXkU0EVsZLrl6AOoWQXco7w+oF3IPOldOXO75YuDbi3WW7VDhnhNkvlymuPMtqqH8yu66VPuoZiswTuDikcwWSnVO6oPriPEZYueSglD/3p8m8oroyNULt+WiCzdpvaeGkmKdxd3vO1eTLav+YA6zN59LW9kfUISs198E0BtYiKxqB6hX942wkJuY6esHnfW6emunXhJXVf8W5CV0/VSPn8sxYgF2OnJl42g1+vgyzVHZ/44Bv2FJSIorNQJV+/roxD9q4qgqYnxZi10BLN5Eyogy89jTgcBIPqLiFficIDIPBEYP8bkUITpaKk7IpeQd++yVAO18qfUVp6goZvQaF9MG6603d/StJtw683qy53/pgojNp/i80G/eCIhQmasuXKiOVoytLhMdGmYbVXGf52AuraVy3LjNn90E2MqJ9Th6r7AUGZrBdDY6hkvbVGsLFroHXVr39mQRexWO22mhYc6JoIJ5DGUDf4t3Fmty/D7U6mU5dMPXpOM/Kn9TWhTL8uBfvrM9fCR+I5/3PIl4u80AwvxlrrcI0zxjktfOzOE1HiiiPZYSAH41eMYc/fJOTVAAkPRIhq/KB07qwZ1nIoT/qgQKfA5RQFbDkgVisxlt+5+0jPnzLDWZ4qF36HfEHyNkNV/uvQa+PiN310ydWdehSE4MtCkT/FXY2bJA5F9rPK60k8GpAAPP+ji+eM0KFOepsiTZQahJiJ8OiXNnFCmF/7gwIYOWWDbzjpsE/Q6sr3Mnpc2KBsVD4WNcHJ32PMmfJOROwzRM/USxkuy1CCAcLpFKogOJojMPSu+or7DN1WnpLUUgH7CTaMP7xGg01LZdouPuv/TBxoWv9ofN49wkPytF3G0y7EqT8pGh7d4D8V8ArlYzDxxyG9Y1nLwEBdgdgBWx1
 eC1IcUsE
 Jkt3a0khP76ueea0HwbhG/o5CGLqJVSz32fXJBZKswrHl/i29hwH0nJBbu5IutR6xyHhuAwPDNHADAGK8j2KnVBhu75Dq7FMcYBkiQTPuuck5Q2V5oD/SiGNJNL8gFnuFFOf8LrDrI/kZeDaYz7TjAaJ4vi3SD2rbmfyzUiMME8JSLD8Ny4GZc51aLmuC8jBd8md92Fy+b3xeIlHLp3pUQI659yuHYPnWVcMytUdazLtEMQ4rVltPa/DQr87B6ZLpdnAKoqIVeAS3vhBq9Uadetz2Y+UN+i2ALJX96aOEvUc8KMQrv00uh4a1gMJsCpYBpQlpZfsImYZvkSnDOP0ux6TXeB7J1Rt6448FXA0+oP6OqnIW2M3u+I1oG663ER0BFgyfn3uEOkoEkphZsPMLIETM8z1EfSn6UGMMlP+rRW/yErut8PTv/RJ8OPunbpcS3ZJSyxGgFRY43uPzqzoBohYQcsXvHQtsCyJsWsgFvL6q5uUJVlOflvQxQmWZKRDlYTeZfcUL9iPp1qwS3uEmUnXpzob+RBeISEf32SWqiIB9dxeBuffvUzA2e40TxRpdIv2SlT1yOQpJcICro7Sn/gk9KesDh3FQ9ECH5uHT4oMkCGoXHy+x7Ksj9ILjmiEmx2uI+GMev5hsDst4N9Jqt4WEG/L4RjY5N/GNINj9awCzC9RMz7T2/Y4t14iBjnu4fx3xZAW6a+YR7OPjQhwcVPYClwVhl92Zdeo9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 04, 2026 at 08:18:24PM -0500, Sasha Levin wrote:
> get_temp_fd() creates its page cache file with O_TMPFILE in the current
> directory. On filesystems without O_TMPFILE support, such as NFS, the
> open fails with EOPNOTSUPP, and with it every test that needs page cache:
> test_memcg_current_peak, test_memcg_min, test_memcg_low, test_memcg_high,
> test_memcg_max and test_memcg_reclaim.

virtiofs is another one: run from the kernel tree shared into a
virtme-ng guest, the O_TMPFILE open fails with EOPNOTSUPP and the same
six tests fail.

With this patch on cgroup/for-7.5, test_memcontrol passes from virtiofs
(15 pass, swap_max_peak skipped as the guest has no swap), and from an
ext4 directory it still passes as before. No cgroup_test_* file is left
behind in either directory.

I found and tested this with the help of an AI coding assistant.

Tested-by: Kurt Lin <lylin1023@gmail.com>


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 774FDCD6E57
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 23:01:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C65D6B0005; Wed,  3 Jun 2026 19:01:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 777436B0088; Wed,  3 Jun 2026 19:01:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68D716B008A; Wed,  3 Jun 2026 19:01:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5AF836B0005
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 19:01:31 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0929340626
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 23:01:31 +0000 (UTC)
X-FDA: 84840124782.01.28B4B01
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1A11A40012
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 23:01:28 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZMuHFruN;
	spf=pass (imf01.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=safinaskar@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780527689;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b1JUsgVJ7d9U2h7quy8Vg4SoAkC431+Nv0NzGMCDYE0=;
	b=yl3JZI6I65Tgic8gkgjVuMZdViXNoEQfv9kflnO/QDbPdEQgTzlciwGZS/fNB+93DozdMr
	ORS6CX4OQBjUZkYvCYcHK+omvQTJX4EOiQ+xWDWcoYCo7X77uJl7hfD+PlRp2/cUnaA6k7
	ePWhvQ7O3PyEJzKrUHXIvDnVMthC5XI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZMuHFruN;
	spf=pass (imf01.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=safinaskar@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780527689;
	b=xE3EgocI4yINw56Yq/DidfXhQSm2EqpwMvzU2gI//RRTeBfmNo5NEYA7LroKJosdUEk4qS
	6BHV+HXLcUPERgL3oPMzSC/ZEJBEk/24qCAwqzguf+GItBmYQDai0SEK4jUb/3C8Lh0s0o
	RRAz/uXcRdpRknS2wp9VBses4BqPjnA=
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-46019b190b6so31814f8f.3
        for <linux-mm@kvack.org>; Wed, 03 Jun 2026 16:01:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780527687; x=1781132487; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b1JUsgVJ7d9U2h7quy8Vg4SoAkC431+Nv0NzGMCDYE0=;
        b=ZMuHFruNNAZbVyBAR1yFUtlXGXRRLgMlO+MvceNulAMc0DxdT9EXYBQcD0lDmmMAJv
         wikzUsnM4AyrAlbKQ9k2F9UQDUKocKNKGF2xvHXNifvf9gGNECjXsQzTtsudkrSImwbm
         Pi/E+dUo5KBnVKDksHkobhMG1Eg73jmqoTmcRv5CLWtCOm097/xJprlNNK8VDKh6vAH+
         YYX0GfwGIhQ2LC5yyPYfrBGWwtoOHjV4EtoW/uaaqvHPx61WyW9niAgSQ+g69KHhN/nr
         ElLeqzEgzeqBQNpPPXCa0o07xhX/YT01+i0FZMh/KmrPZicI7Fj23Pfc5PfNa7sXcsCR
         hD4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780527687; x=1781132487;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=b1JUsgVJ7d9U2h7quy8Vg4SoAkC431+Nv0NzGMCDYE0=;
        b=samKcRcGIWyui1hNpsaEtshDROcah36L1PXsnIyvJSlNdq8ID6DzysQVlDyqNTWzCA
         B4jq3qL/4G4zE+8H+RMO1p2arcno4nYxNpZw34kJUR5WQvzOF8OdDSAD6qBDkRMnPtND
         Zc05JrhflOZytBan2iX8DBzgRR049RbE5PZLGBZCwDy0HYcJwqW55NNnw6eeFApDReH/
         r/a2dqxROptImyRmMYG6yKwZLSKYPb06Fiigv+03xJqL/FRq8q9aj1DyJspAbhkwprHi
         62/DEyEmie0YJb2FEUGCrXkmY86GahHg0Dk5ZkXumJR4czunPBiLFBKDO/BCZDIVVd6n
         WhJQ==
X-Forwarded-Encrypted: i=1; AFNElJ+QFaryEnlCQuQ5HJVxSEo986nqVJMjMbptQjut+VmfkVgOPihKtz4MqjRQqhgxqH1BeZO32qwbGg==@kvack.org
X-Gm-Message-State: AOJu0YyNQnJ3zUURL9fRf6MdKQbeLa+kyAZ2FcR8jSg24ZeIYFfX2PfB
	hcf4CcSHaqJjITW6p3gOEMZ0IgvGaV2HDpTK86KdA3hCIIMc8bT0hHst
X-Gm-Gg: Acq92OEl0PYhrrAlf33rePkDsu1A/6KhXG2q8KTACPPr10puKiUZkg9DWWzsZvFmDbA
	nLyYU01G86sVD+ULNwGA5IQK855swdolgLHwa5bFWfrDpmZJJaryYKRFZ0tsCTbvPIdX5a4aC8W
	IVs0edstDgYNj3jaT15jT2ivI56s3C4/KV8lyTHvEe0tC1TCb1em9OdDf/eBDZck9aLKCEDibnU
	ABflzoEG4y9RT4uYEbNrqq9Gz1Mjgw60DBIp6Wc5h/Hv1TxH8baeK4kIQ8n/zcELOSYhrMUX4lm
	HaOg12DphX8Bh0wZYvVbKswGqLwFv+f4l2E9Q7P0rN7/O4tdA8zdY1cDYmBJukniN+hcYURfy5+
	atXK91yzXPh2MBX/QXurBs6l3H8fzerGLJGzdLQ4dBdJF53m9R3JsAazabR+XWSb7iGv0BfnZcl
	ygJ5b9Sf87YfAa53UOxjoNHEGT7jpoEA==
X-Received: by 2002:a05:600c:4043:b0:490:b2a6:8c2a with SMTP id 5b1f17b1804b1-490b5e748e3mr51931455e9.5.1780527687138;
        Wed, 03 Jun 2026 16:01:27 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-490b7e6c6a4sm45890145e9.2.2026.06.03.16.01.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Jun 2026 16:01:26 -0700 (PDT)
From: Askar Safin <safinaskar@gmail.com>
To: luto@amacapital.net
Cc: akpm@linux-foundation.org,
	axboe@kernel.dk,
	brauner@kernel.org,
	david@kernel.org,
	dhowells@redhat.com,
	hch@infradead.org,
	jack@suse.cz,
	linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	miklos@szeredi.hu,
	netdev@vger.kernel.org,
	patches@lists.linux.dev,
	pfalcato@suse.de,
	safinaskar@gmail.com,
	torvalds@linux-foundation.org,
	viro@zeniv.linux.org.uk,
	willy@infradead.org
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
Date: Thu,  4 Jun 2026 02:00:25 +0300
Message-ID: <20260603230122.851517-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CALCETrU94ja56CA5CRtXrm1v_7gBaPUNOHKQzS=JNF9JZ7Fznw@mail.gmail.com>
References: <CALCETrU94ja56CA5CRtXrm1v_7gBaPUNOHKQzS=JNF9JZ7Fznw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 1A11A40012
X-Stat-Signature: 5qpfn7euyfjisypgrjqbr93cqqfqypho
X-Rspam-User: 
X-HE-Tag: 1780527688-992844
X-HE-Meta: U2FsdGVkX18HDtdtYsRfTxiqYJUYGvzMNkJ8kd3zqz6oKvL/6zH4xzv8IYlSYg53uLLPcAG4yUPB9EbUExpmr9SntDszxWtdSz5YCKb8Xk3vzT7wJCpeb4ifQTrThb1cscVxNk38pbwDVtx1mAZi6E6OQwoGA6SiBSm6XK1aWFBA61ag1xL3T1BlZGVEQH/cu9gtSyqSLjrb00iOdLx7eQb8VZ2BPe7SkxvJEzDAPokFzcKc6+PP6m/gHPWouVhrtvy8PP0oSjMXPK5o+ENVqkDz/0oTMUsMLCqdIyCSMkFw8snr8kUfOZ1AkB5x4t3DPWESu0W0QMii3O91aLEJz9XvOtyAP4qVOFh3Zlp6jQs+mx7f8c/Y+70KgaZt5i/YNIzh/uARPj/kaP4zm2LmRyaeYXa4aAdu19t6uoOzDDC3npMqJlqVJ9VomzaPzFeGWFufO2lMrdljdPATXrQCiqB9C139iHO/EQySBKQ5yfOV0Ol3q+RYWiQBl7A3kew9mmPAvWDWVYtl1tclTF82YMcMfvILPqXIzzFLwE6eUOTGuTHnthDUXYF/DQaXnotaLgFJj9E7WEcbYlwD56yaSTfqXwPVuiO1aGkGQndz8lyP+da5neB+Bv4e95f2e+BQokIDJlQl46FZy39ij9BznwMw3KlQXjoAPPyu06yKM609HNfPQcDFoY5YURDhVI65wL1hU+Ux1bzXZ0oXXL5hnFflAa4c2F9Onztb4FOKV/0Bgcpnj1VeVLGtgKUOS7fJHf5DoBhKZBulNsP9CaYZ/CECfX/d14kXdJX3C2uIHhfbH2EWVIJ8ggsV3rJt9tqJZBNOtZiUSYRPizgC1Q9Pz2/xxXbD4kKmOY/14RzetIZxax8x1IH8bW8XdULeDKIK+cRhO802eXh+Ezi3I7zOL3Oo/8lWf9J1E989Me/zp56UWF8IBidl6TF7Cr5Nd1ov8MIz5PXok3grQ++x9UA
 y2cEud8D
 tE2v477Jop1XA0XQ68OmklT4WrNWL/MllevkcEhKhtFdmk7VsEHP/imW28x2lV970iEnXVuxESEV9pyfKYplF+47F8JVjJQhrZLQt3K6R90qkvPZ5KyUeWUhqENjlV2+1VJQLmtvOpI+QwG3ceujUmyEqOpImjWarjOTZ35OkShW6iV6ANV8Qc4xrO946a0/veMm1yjVbv9M+O4EKblB5TZnim7pb7B3VCK/NwqS1+8wlNLq1ABKHSEX3cAbLCjAX2SjRSWGnKFeIkzf8n6ihC+GMHZOttt+79E9nS1l471o9e/SF97hAa0s6/fnoNfJuCALv1NVDckp2vq88j9jfV1sw2P6p5G5PQ3nIN4mChBRB4TvqkOYkVvLU2cRvnzl5jn51t1IQKRv2bRw1HPcuF8sUzliWqRQosN5P20ss5XRB6O71337HJWlOe+6x5gjxbbocsjCjtChJESQXEKu86udNlF+lt+zfS8p7xWvgpgDRH7mq6nu6evrWjU5skGfVZbE+7evj5K6c+pA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Andy Lutomirski <luto@amacapital.net>:
> On Wed, Jun 3, 2026 at 3:43 PM Askar Safin <safinaskar@gmail.com> wrote:
> > Finally, we can degrade tee(2) to copy, and hopefully this will
> > allow us to always be sure that pipe buffers are not shared with anything.
> > This is possible future direction.
> 
> I'm a bit nervous that, if I've read the code correctly (a big if),
> then iscsi and nvme will still send *shared* buffers via
> MSG_SPLICE_PAGES, but that normal user code will not be able to do
> this, and that something will bitrot.

As well as I understand you correctly, you mean that if we remove
tee(2), then there still will be subsystems, which will be able to
send shared pages.

Yes, I totally agree.

So, if we remove tee(2), then we will probably need to remove all
non-standard implementations of pipe_buf_operations.

-- 
Askar Safin


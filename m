Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65E9DC79F80
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 17:00:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F47E6B008C; Fri,  4 Sep 2026 13:00:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0858E6B0092; Fri,  4 Sep 2026 13:00:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E88DC6B0095; Fri,  4 Sep 2026 13:00:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A89726B008C
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 13:00:46 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0ED8BC0180
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 17:00:46 +0000 (UTC)
X-FDA: 85176694092.08.F2E3FC0
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	by imf29.hostedemail.com (Postfix) with ESMTP id EC0C3120006
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 17:00:43 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=black-desk.cn (policy=none);
	spf=pass (imf29.hostedemail.com: domain of clx814727823@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=clx814727823@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788541244;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GyJwn4+ssjywZb/F3JjOY0S6/aIo0tP90S69DFDLuSQ=;
	b=NKzSjBPslbycIhcRX8TKtHtLawrlb4CbYR/VyEOzvMhHG5CfQs3MWjYvIIvzJgDZAoHS4d
	qSvwuk7/0VWYyslNtH1lpvIZ8UTvO746Phv+881/5hFNtV3ilEAByi0aaI3TZuUSkwKuuF
	gNup0SxWf0lIsCsd2E6GmzpWBle09Vo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=black-desk.cn (policy=none);
	spf=pass (imf29.hostedemail.com: domain of clx814727823@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=clx814727823@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788541244;
	b=HQd2J0TA2niZY8rBlUTZzgJUdXGalm2MIhFNE/cqtJn00cM7ChR1DtuLUMBupT4Oe7ERXt
	6cBZzrh2/o7e7Oe0OrrDooOdOf0PlmKLmNZ52Wu+JylnwFfyyXBpWaJtZn2b4JAugQSWEy
	ZbCpEWZghS4nISW21Jkm+CO8XS188sQ=
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c20e70a0962so161258966b.2
        for <linux-mm@kvack.org>; Fri, 04 Sep 2026 10:00:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788541243; x=1789146043;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GyJwn4+ssjywZb/F3JjOY0S6/aIo0tP90S69DFDLuSQ=;
        b=k5uqdVD3ZZQOdGLPmQXFrfW/5hCQikShm4sAlwVj1/YKLgSz8upWKVx2zm0kExcS9E
         zyKvg4iRsuO4QpixYhRN06yvcSuLS92oJVaXJki9Blrv/v2fMd61ghHc4qvhIKIGE0Up
         j0pqSODNzaUNqFkCJvyTMy1LcNFydb81PVuCbtlI+4ywgrsi98R8WhcBxxc47+tomidp
         2TpdsMhDW7k42kl6JGG7WDjFo/0YhIBCTKNH1kHL+r+4jxxfpalWcPVnmVDBVwz+mufX
         yPTps6DNUBU9DwtgKlMyjZ978NNhS6ybdlycL3WCGQ9sYp3MlV5sBVjrv197ZfB1fbuX
         bgsQ==
X-Forwarded-Encrypted: i=1; AKwUvBzxRKV/4w4RtkuDF57M4ZlAat6YA1BSzswZ8GRsxuwReOYS/anu+WsIguMIgqntceX+1X+mggmN2w==@kvack.org
X-Gm-Message-State: AFuF++kcFV1QDMLiwy+bBwuF0VJMztvfehzKkUHAlzos5Au7CKfogtF3
	Jr+3t5uQY1v8pWAhztiLZQfjKxw7qEKooI+nvGTX36aQJKgAn+3v23dAQpFiiiSQHZ6XsQ==
X-Gm-Gg: AYBFou0Y3Us9RcNCvLyOnntEOrwJIa1ogeMaaKtX3e0ZeYCRJh0gtk9/pmhx2LR/qQY
	WOASf4d+Vf6NudzFeX7BufaDDKcC+u9gXRB1VF0vh6+R4gUL+A2YMde0KD426pN/FNYnjwk1hPR
	DGmWD1CwwJcUeNQ6HZtS2dSLVUkpGOs0BuADFWlX5Ao0IOX1jl/LOgU/tK0gUZSKVYuyV/OILaH
	CiU2qR7hhARTrKcQFcHiA/z1a/0ClH1m7q1ka9Q2ZgKnbnXaZ/5qM59yoXaN3rE8tiS+QCeQjgs
	5I5R86TkSVxwdHbll+FWJzhGtz4N3f/MeNTBRXzMyQhdODEYhepuG+czkONgYKl+mVne4CzUXrC
	zt3x3hjJCWkNGhF2IG6AmiAaPkrgPYgl6N8Y6R8/to+S6D8j5mbCmPg+HZJBBLtIRM0aFk5HqB6
	8UMDTnMSknkeX+pEMlbCVXOWfXi/3vicS/+oKlTlwEkq32uxH6eCFOQGW9dWoovj253GFBcinNj
	iUT2q/phtRYjfZ9CfvvNBByGCHnCn+ZD2AIMGBqBYcI9lfCT47Q
X-Received: by 2002:a17:906:f586:b0:c20:1bc5:7002 with SMTP id a640c23a62f3a-c260c6a0e2emr525025966b.3.1788541242483;
        Fri, 04 Sep 2026 10:00:42 -0700 (PDT)
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com. [209.85.128.45])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c260d5277e6sm133600666b.27.2026.09.04.10.00.41
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Sep 2026 10:00:41 -0700 (PDT)
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-49b9320423cso13596185e9.0
        for <linux-mm@kvack.org>; Fri, 04 Sep 2026 10:00:41 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwe9aCpzFw6XfQb8nK7kbZpDiD0Z2vX6x1l0BekmSCDuG57iwqNVSl0kXVnfTmD7CZS0SFHA6yd+Q==@kvack.org
X-Received: by 2002:a05:6512:3502:b0:5b0:23b4:be97 with SMTP id
 2adb3069b0e04-5b616ed4b1dmr2357411e87.6.1788540878064; Fri, 04 Sep 2026
 09:54:38 -0700 (PDT)
MIME-Version: 1.0
References: <20260831-pidfd-get-paths-v2-0-c59ea6a21b72@black-desk.cn> <lhuecf9cbl8.fsf@oldenburg.str.redhat.com>
In-Reply-To: <lhuecf9cbl8.fsf@oldenburg.str.redhat.com>
From: Chen Linxuan <me@black-desk.cn>
Date: Sat, 5 Sep 2026 00:54:26 +0800
X-Gmail-Original-Message-ID: <CAC1kPDPu41RxMLHpPtz4VqfkEZeu-fYXG76XVZMh8bbQa3okaw@mail.gmail.com>
X-Gm-Features: AcwNN1UgBltmpHY5GDpzTdve1vmhfclnbN_NvQgKzWwvr0zbygpAGe7Eg-teU9E
Message-ID: <CAC1kPDPu41RxMLHpPtz4VqfkEZeu-fYXG76XVZMh8bbQa3okaw@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] pidfd: add task path ioctls
To: Florian Weimer <fweimer@redhat.com>
Cc: Chen Linxuan via B4 Relay <devnull+me.black-desk.cn@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, K Prateek Nayak <kprateek.nayak@amd.com>, 
	Kees Cook <kees@kernel.org>, John Johansen <john.johansen@canonical.com>, 
	Georgia Garcia <georgia.garcia@canonical.com>, Paul Moore <paul@paul-moore.com>, 
	James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, me@black-desk.cn, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, apparmor@lists.ubuntu.com, 
	linux-security-module@vger.kernel.org, linux-api@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: b57zct6roycn8rs93kyox1df5ywqmaxk
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: EC0C3120006
X-Rspam-User: 
X-HE-Tag: 1788541243-323496
X-HE-Meta: U2FsdGVkX1/Vjh2g7fDfqZ23u8AOmvpZ+cNA4rVQMwcOFeVfk6CaQEGP7yB+sBv67ah0n3VC9Krd+lwqcM2ikv+CAetRwOENM/8Nc197gXASz+uQmMdxg52PMx02wPMx4/2rGVLeLmOiMORdQSZj8lZmNXIRFVwISCvd93Zaw9Fv2vcFwFGoZ3U1D9KwEB7QL1bkY7ZAcnT1MkEke9vUF/Oru80Qgdw3Tq2EJl3hXkiVqx3hYGyzr5d+NlTrlNoitQf7xT0CEPlIt8Pinfq96xmVhhaCBZxXYXANAvet2Awh2UJ3gSy7asRu08fkfoZpTyl9QpjBYoAVF4/jGUnOofcQANIPj2lZadO2X386L6cEx7nbjji4eZoaaqP+lvMd84dBxGwwT7XZ7sjRzL5pjt5YrboJmEVM1LENqZy/Wm6dInrxkb0GDyAZpeq3FTxC1mX3v3bm8F/kJGHf2vWHm+TaC8ZvfWHZf1TODhK4v1aLsE77s6LnaYW6CYEjlNxQ23pp9wN6z7je8Vp7PSNmrqXUXX5nLSPTE6dahnXEBRVE14BYQ31pXu+xVfftTFk7izbOoR+pIX6snFJTvFLR851q7empp/mwgPWkFlVfWpKRYSoCXLnA4Ky0BSy4YOB0TQ1Uq8Cq2XNgdqyuSn0gEC9wuOU6fFrd/lCbPOGoI/+U1X6m+J9GPcKVEQmbuKPkm7M0zhpLiidTZs6Zu0sWI5DBEN6JLisQUz3m1sucd60INnaqQnX8lzVFDfaHQFb2EoqjVyAcZmwRhwWSUSmLKLbMxLvTLJ8VHSmLW/3MW9CT7ZTTUK2rG9tyNQ8/bd4KZnSWHWp9+gZK3jjj0F3K6VmlEDH7qPRgfuYawa5iWsNU34WHC4nLerxm4Q+AhUGk0MkNJWOEIhJUmmbkhjlHUbFPMauZ+nwdO/p0QcAaLL5jILgeEzfLaO69c/jCaXR5e6DNivUGCuzv3d4qqRw
 mf1V1tu4
 agVT06nrxTUR4eAMqFz6/56H8emF6HW0XAxk6Lpp/mr3Z3+XLo9Un8h6TsvT8diirZLSVOg17u0n85IrTDnR8qfOxiKMIekx1EJVDvJKkSkkTjxaiIW5w219EC4oGqH0eeAy+JCbXaecD6lNtbf0BqRbq5yL5B+r2MmrmEBaI070jFLAteHv2qs6Cfv0X37iKQSgR4aZj90aDav+5OTLub4weMiSEN/IF9PDyep2gbt+nXwFl6XTkKLzipRhyDNzfhzwLJhDeVOd9xuRM/M62r9dAriwKobjALKvrEsY/vTepmNnBFTC4KZQX7nCKO6gEapKqu9sKb3UxVDj7r9X/NuT/CNIZaJW42/iu3PaLsNx9LxG2p43W957+IVqCp5t6FoSeQTkv82OzwF1YKKxq+igm1JHZ4qq+ovnJ9du4fuWF0EdBY+EgzUnxTvD43ktRuBQNf1t4emEhZZMRPMqjdV7AB6B3i+Il1+XFJOPWXQL3voCprN5GUbmk2EkQzpyZqBrMOAwqBdfJvSOK+pJiC4XTXtQLEtT9FQaHkwaj1ExRVd6Wo2VIzeui5Z17vtZ6MjfIsDRIyTp17+I3XQgTMX5iAw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 4, 2026 at 10:53=E2=80=AFPM Florian Weimer <fweimer@redhat.com>=
 wrote:
>
> * Chen Linxuan via:
>
> > This series adds PIDFD_GET_EXE, PIDFD_GET_CWD, and PIDFD_GET_ROOT. Each
> > ioctl takes no argument and returns a close-on-exec O_PATH file
> > descriptor referencing the corresponding task path.  The new ioctls use
> > the same ptrace permission check and nonzero-argument rejection as the
> > existing pidfd namespace ioctls.
>
> How would one upgrade the O_PATH descriptor to a full descriptor without
> a mounted /proc?

For PIDFD_GET_CWD and PIDFD_GET_ROOT, the returned O_PATH descriptor is
typically used directly as a base directory for openat(2) or passed to
fchdir(2), so upgrading it to a full descriptor is usually unnecessary.

For cases where upgrading an O_PATH descriptor to a full descriptor is
required without /proc mounted (such as inspecting the executable binary
from PIDFD_GET_EXE), users can use the newly added O_EMPTYPATH flag with
openat2(2) (introduced in Linux 7.2) to reopen the O_PATH descriptor.

>
> Thanks,
> Florian
>
>


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F878CA0EDC
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 01:49:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A079D900029; Tue, 12 Aug 2025 21:49:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B57E8E0196; Tue, 12 Aug 2025 21:49:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CC2C900029; Tue, 12 Aug 2025 21:49:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7C18B8E0196
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 21:49:44 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 52193C01DC
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 01:49:44 +0000 (UTC)
X-FDA: 83770052688.24.EC8CB39
Received: from mail-oo1-f53.google.com (mail-oo1-f53.google.com [209.85.161.53])
	by imf29.hostedemail.com (Postfix) with ESMTP id 7F2E212000A
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 01:49:42 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=myfdsOxI;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.161.53 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755049782; a=rsa-sha256;
	cv=none;
	b=bNC1iayRfv4LGF6UZrHaxoO7vqho8FnFnBxYBXmRvYa3KcktxlVBDugYO0DQWmK3L3DnDM
	LlboYTQ2Zm6u/6YN+G3pcpyiKcv0Lin9vxEXbUewhR78vDO96ZUI98cV2z8pqYtEPB7q2u
	wKAxlzhd9Uruxgz0vjJ1WSrPAyRUzDo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=myfdsOxI;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.161.53 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755049782;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Aql2mwv9JTABH+xYsNRLchplJ9jbZwWvArEPle7Cru8=;
	b=8KGFRX0ufqwl+5jxvB3BvOZTkKSiMn+LLe2/1X17rqsS2DoxLk4wfzw5oNaSj7q1G/SApl
	ns1i1uqNiJCgm0BnQda/ESUeWkT+ThsGCR8YBV3Cinr8ucvQmpxLYfyQIZzdOuGNuYfg8t
	gDW+ZYNDU28CQYBxHNUg+UK8g9QQG88=
Received: by mail-oo1-f53.google.com with SMTP id 006d021491bc7-61bc97d9c28so87989eaf.0
        for <linux-mm@kvack.org>; Tue, 12 Aug 2025 18:49:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755049781; x=1755654581; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Aql2mwv9JTABH+xYsNRLchplJ9jbZwWvArEPle7Cru8=;
        b=myfdsOxIeCq4jTl2MVUcXhpj+BCiw6Ldh0LmqwH2++w/oDZM47+6QdXsf/gYytY+0y
         PdLI9I7+kf5qCxXg3rWir6KlrtvLd0rE8TAZve6BA7qMNu8CJu6ERWEt1gF3tWu9oZUu
         Kq8YGCaHr9QiF/2hpHaeO/JB4EIB/m71dXPWBr5jUK55IsvHt5VQTZcJzobr4DkJA3Hf
         YK1e9Og2RtKGnma5HCx4C2lqAa8sR6aaEu+/tPTZsrn4pUuouyAMz6W2tx4CZC+obm4D
         ljRPt8Cg0as1ZFWBC8fhkvhui0E4UqKhCJWCYbIDupJJSLOrjjEfgiQw9WHs6BEm+1Qw
         WOnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755049781; x=1755654581;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Aql2mwv9JTABH+xYsNRLchplJ9jbZwWvArEPle7Cru8=;
        b=bdivZf41w+T6X0Qi15a7HWqwosmY82OpTgGDVFaru9RTGGCV+2Ny6FSJcs8g2tsdmo
         Cx6IyNhrzO7ck4U7jWczFdow0UP5YgbnXYGL/Fzz9rFkVf9jY3rWRbPOg7K/QJlPS0LS
         7AxWQvUZ8pP8x4NxUXsgubsVtKEdZG5mzEDk9Hgc3H0Ay3a7ELqOZ838/mZCTy+98Myd
         BS3zm0aXcHMHj6laoaNuQNyo1ruRSyl67edLpZwYxkCvZ5GVc3yo9MtLu0YQswuStJ4a
         ueElVRa8UoHrhxMH/S6tsOlrbRE+MnsJpECvuoRJPBaENZuUxX1GXmd8AFTdT4guZ0Ox
         uvKA==
X-Forwarded-Encrypted: i=1; AJvYcCX18zix5sT/5Hu+Qv+umvJo2DfoJ2+80ilUORLjE3oyNUyJLadkhd7MXp0tmmUymThBJwmbenqPmQ==@kvack.org
X-Gm-Message-State: AOJu0YxwW2KJoa8ndRJoNyJMcz7pTVaaX2T3QZ/sjcCjLsX+P4gS9c4b
	YzKyBXTMN4Wfi+mUSXjlmIgvJ89FegqJZ5pNR27e3qcBQt4xIVjUMR0yDmypayotUPufyyZ8Ds9
	T2D3puPyXPthro2zClmB0rMi+T/fNITw=
X-Gm-Gg: ASbGncsVM7zErSmRwaYVvYOYBXX4pnL55TWC93fPgaLxmBM+2K0biXEe7uYBW/FxXJT
	T++72ZWWIctvpionlcye6Q8yWjNd+q8dWcVwx0Z3t4hETpoDkigBhjQprXjwUnvkLmuNhmn7twO
	2DuSjVL5VQDahBrpzePy88UocbHMlLrE6zetw0j0G2jxeZ3a8JJH5d+EN+lWn8UYSAYLKOQjRvi
	gGv
X-Google-Smtp-Source: AGHT+IE1J0i1gE3lpjE8L3r6M3x9LWFRM4yO8xP7DHLQDKGQcNPsPKYKJZsVHZVkCkUSbZlkd0WOpEdDB5+y8llfm/M=
X-Received: by 2002:a05:6870:80cf:b0:30b:6fa2:6974 with SMTP id
 586e51a60fabf-30cb59e360cmr834687fac.3.1755049781191; Tue, 12 Aug 2025
 18:49:41 -0700 (PDT)
MIME-Version: 1.0
References: <CABFDxMEQYx7fdx4T7meUb01FoqJaHcW_2RoYnBwJ8GzmJTexzQ@mail.gmail.com>
 <20250812172001.57104-1-sj@kernel.org>
In-Reply-To: <20250812172001.57104-1-sj@kernel.org>
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Date: Wed, 13 Aug 2025 10:49:30 +0900
X-Gm-Features: Ac12FXx-U5LfozvxZM7PlT1XRtOr9ed905rkP1AtucJXvK8shutEgO6eRp4XuMg
Message-ID: <CABFDxMHjYDZDf6cObeKMSWmh2p-eYy_Nggzg9FK9HOXB-Pvpeg@mail.gmail.com>
Subject: Re: [PATCH] selftests/damon: fix damon selftests by installing _common.sh
To: SeongJae Park <sj@kernel.org>
Cc: Alexandre Ghiti <alexghiti@rivosinc.com>, Shuah Khan <shuah@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Enze Li <lienze@kylinos.cn>, damon@lists.linux.dev, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: dgcjoxyanphpigz8r45r9hx4zsxndais
X-Rspam-User: 
X-Rspamd-Queue-Id: 7F2E212000A
X-Rspamd-Server: rspam02
X-HE-Tag: 1755049782-762525
X-HE-Meta: U2FsdGVkX18yCuhHdMVY9fa08Hilo/mfBzCj9bU6GOTyqyjT7aXqS9ZODv0vqhcEbKjcbytRrN8KgoxNOI1vzpFReq3ttT9eH/V9NE5X57Mp41xQvgq/YIQySJNU+gNnXJpU0Osj1/evZkrod/Klfcse7YmB/wNi5YXdLlao/TcI6rwx+DmTnZVLdFaJalx0SGmrwmftyjj+XC4RWZZ+DQFL6/01QQkXNoCCh5pfZ8MaDNYr4eWJGjR9+qzz7TGe/H1rWzl2Np78WdoSYlx2fAzoahHkpniKs0yLj1htd6BncZ69Q1nRof1skp/zeFCOVlCI3GtaB6oPjxBgSYhV6YuicFUzdj0gCSKUlcjl1h4zfItuDdm5jiwz5NITxeDlLJdG6ABpHZGkk4tcMnGZXPwZv0EO+FG7jp7xnL5hYMUk8nzxTSzzp/8yjlLVr7YzcyjzzRFximXf0Dh9S5H6T48yvcGiVHHBczxzlFCdO9EU74HHZUzw4NA8lZpG+eYROqB23EagGoKF68pLiXEB+ZykgGxCnC8ynIvLFqqrcdCkFPDttQWjqGx+DEh4/++PP+fYCHu69tbgwgEtv6ixmec+aQrFKsksvKFnIPfkHHMUmxETZIRt34V8LWu19g3DG2gcEg1LX5I9qJMQbcbMGAMo6j114fhjqU7QHpwtb7xNqsSLEv70bcCRPNmcL8ovP02s2zDeYc5NCupjSCnBGn2JqN6uNiwnByD3rCIC3CjCIWoSD2rYHQ5mDrTMQ2nvBh9wzW1g6OUQelZaBa0Tzz8HjUPB8S1ItbHQ+E4z+/ulLOxGghPmemLaAvHpYwpPVz/OUsmeJg1SwqowRbla8xG3SiipyS+iqDK4G26PNZH51mSblXSzNmMRQ22Mcz6qUH7LTtAe/dmOk9xhs8xTrHXMH/tfzClpbzT1rYtFZBk+rWYMlgKQAdPxHYAdluZjXdcgElfbgFcL9e58P5X
 leylZM10
 NDtW55gne8Dz4FbaUqmroeCFzWw6fcsrNk7xOkWeDHOkHlx41E4Web6ySot4880nKHA6+TwVovNeki+3DRnYIsrxEte3Sx/E54L5/qOyfOuVcdk/A5oSnGuyZMd2t1PoedZHQfM2l3ZlCCFXsEuiBFxxdpzEVFeWkUqcOmc40qvtH722wg5ZJNs6O/SNSk/sYFGGySV3EIHDa5SFsky+xKtXXLg1STWKVjMIKj3LUaAFisX7YRtLfT57J2MsVU/0eOlaxDiLEFWwv4LyTPi6o9ZL+q1Yxtrqe93+a7UOmjtpXVNLw96DRaZzFKLH2ai23YRxo6nKtxxjBu5p9UeYe4qoL24yeAiCduT1QNchG/CkfAxhTOIJ0k7hxtjylhNeldbkLpck9uvwB9+F6qFu657DcBtBODRCMlKnW3X1p+0R5r5sPeYs/iDq0AkyigJnWNtM7bKxZ3mEtt28Yc4iNXJLQyYlWO3VprBBct9xKl5Ib/ETlUQfGAIhkSVzuuDx3hsFfhMbEl++4l61iq6HgUCTvYw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 13, 2025 at 2:20=E2=80=AFAM SeongJae Park <sj@kernel.org> wrote=
:
>
> On Tue, 12 Aug 2025 22:27:00 +0900 Sang-Heon Jeon <ekffu200098@gmail.com>=
 wrote:
>
> > Hello, Alexandre
> >
> > On Tue, Aug 12, 2025 at 9:32=E2=80=AFPM Sang-Heon Jeon <ekffu200098@gma=
il.com> wrote:
> > >
> > > Hello, Alexandre
> > >
> > > On Tue, Aug 12, 2025 at 5:13=E2=80=AFPM Alexandre Ghiti <alexghiti@ri=
vosinc.com> wrote:
> > > >
> > > > _common.sh was recently introduced but is not installed and then
> > > > triggers an error when trying to run the damon selftests:
> > > >
> > > > selftests: damon: sysfs.sh
> > > > ./sysfs.sh: line 4: _common.sh: No such file or directory
> > > >
> > > > Install this file to avoid this error.
> > >
> > > I tried to reproduce those error with my vm environment but I failed;
> > > with my workaround test method, it doesn't exist.
> > > If you're okay, could you please tell me line by line how you execute
> > > tests in what environment?
> > > I'm also struggling with the test environment, as well.
> >
> > I succeeded to reproduce and also check that this patch removes those e=
rrors.
> >
> > > > Fixes: 511914506d19 ("selftests/damon: introduce _common.sh to host=
 shared function")
> > > > Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
> > > > ---
> >
> > Tested-by: Sang-Heon Jeon <ekffu200098@gmail.com>
>
> Thank you, Sang-Heon :)
>
> [...]
> > > > ---
> > > > base-commit: 2754d549af31f8f029f02d02cd8e574676229b3d
> > >
> > > Does this commit exist in `mm-new` or `damon-next`?  I failed to setu=
p
> > > the same base-commit environment.
> >
> > However, I'm still not sure that this patch is in the correct
> > baseline. maybe it will not cause any problems with the merge
> > though... but I'm not sure. So I didn't add a reviewed-by tag.
>
> I think unclear baseline of a patch shouldn't be a blocker of Reviewed-by=
 tags.
> Since most DAMON patches are recommended to use mm-new[1], as long as the=
 patch
> can cleanly applied on latest mm-new and you don't see anything wrong, I =
think
> you can assume it is based on mm-new.
>
> [1] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profile=
.html#scm-trees

Thanks for the notice! I'll keep that in mind. And also thank you for
always being kind.

>
> Thanks,
> SJ
>
> [...]

Best Regards.
Sang-Heon Jeon


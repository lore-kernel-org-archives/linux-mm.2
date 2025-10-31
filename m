Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 633CDCCF9F8
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 21:01:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3242E8E007A; Fri, 31 Oct 2025 17:01:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 285C68E0068; Fri, 31 Oct 2025 17:01:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19AF38E007A; Fri, 31 Oct 2025 17:01:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0516B8E0068
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 17:01:05 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6CEBB1605FB
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 21:01:04 +0000 (UTC)
X-FDA: 84059629248.13.DCD3BE2
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf21.hostedemail.com (Postfix) with ESMTP id 52CFB1C001C
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 21:01:02 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=awMqbcaU;
	spf=pass (imf21.hostedemail.com: domain of yanjun.zhu@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=yanjun.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761944462;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4M437FhMWrYRU9fL8t9iQDlE+b8fQeZRsavMmMebzdc=;
	b=JcoGIy+1h/h6cCr2x9bz7W+P8nwvvEtVu1GWqZaTyvynegRso60kHWTi8scgHyW9ANx7o8
	TCSeHKb6v5+RC2JL06IS/eXlrjW1gzgiYiFPGyd2zuePGnKBVY5rsTZgt0nkF3Oy7dgymn
	MYuaCV/bnd6Dxjfad9RVGDDYXFnJgCw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=awMqbcaU;
	spf=pass (imf21.hostedemail.com: domain of yanjun.zhu@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=yanjun.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761944462; a=rsa-sha256;
	cv=none;
	b=kJQaNBR2Ii+nlN+OhGaCvuZEs6jGHjRilMG6qxUAX/jinIOylJdLq7fBxIWvjodwq4Qyak
	9XavzxQPlOl/vLFrYTFLgYus1Il4MRYLxshOazGEm8TGT0gNF2TyWsk/VukbZXHemRRdUF
	KBIFTGLWy3Hx307IJwAgvHHA6t5o7a8=
Content-Type: multipart/alternative;
 boundary="------------MKu83Q5FmrLXu5CJIynSSYlh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761944459;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4M437FhMWrYRU9fL8t9iQDlE+b8fQeZRsavMmMebzdc=;
	b=awMqbcaUmmQikqXXPOw2EXUJKAMePrp6SE3lJ49LdDWaOO/xIgOi9KMJpPK8fF2Fymyd81
	rLGJRmowtcGAxIzW1WZUZ6StU9kQXAmJpv8kwcRFGgcSGIagvErjWGZf57G+CADyyH7QOG
	+ijL0HjSwRgmppIZnwWYWYT9Bjg3xpI=
Message-ID: <d710a4fb-adba-4d95-99db-a2d1176bdeaf@linux.dev>
Date: Fri, 31 Oct 2025 14:00:55 -0700
MIME-Version: 1.0
Subject: Re: [PATCH 1/1] kexec: Use %pe format specifier for error pointer
 printing
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Simon Horman <horms@kernel.org>,
 kexec mailing list <kexec@lists.infradead.org>, linux-mm
 <linux-mm@kvack.org>, Alexander Graf <graf@amazon.com>,
 Mike Rapoport <rppt@kernel.org>, Changyuan Lyu <changyuanl@google.com>,
 akpm@linux-foundation.org, Baoquan He <bhe@redhat.com>
References: <20251016200320.4179702-1-yanjun.zhu@linux.dev>
 <aPdVSyLRKeRN3i6z@horms.kernel.org>
 <16b37574-32b4-40ff-a8b7-2b443f293d74@linux.dev>
 <CA+CK2bD+_QFWx-+3sTW5f-C2tKG+bU1Fzk2bUP39UGuGouPRVA@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Yanjun.Zhu" <yanjun.zhu@linux.dev>
In-Reply-To: <CA+CK2bD+_QFWx-+3sTW5f-C2tKG+bU1Fzk2bUP39UGuGouPRVA@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: sjurfd65ich3k5m3k4p6hy4szfqo8akg
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 52CFB1C001C
X-HE-Tag: 1761944462-788504
X-HE-Meta: U2FsdGVkX1/xZUNCC/BnY9ZvIO5t1DiSG280lXxE9fLyJ1w5dwldNp4IW1ELBDaOQ0EWenZLL2fw44ZYr9kc90QJU9l8/wV4tNYlxv3VOTGFIQRW/e/Q+RWW1xAe8NrivC66MWSYSS0FfXK4+W1WBZEE746a5zAFkRIL7W1S1+MKI/wOQjZc72Z//Zpm5AXtCUPJ7WRMr2A7GnYazozblzPRz6pvv8Q/5PZU4yL8t9OpDLFUEfKzfaW2JNKAPcI+AD+Dkf7I9noVeRRgOM1Hi/KN+fMEXIqDxHJUGeIDQBYbF1wwIVQ8W9+e2Q7PoxNK7TSEq8+f+hVaDO3xXsNDvUyOaTG5HAfntodLA9fG/hiy2QE2qtbSz15WHbHXAbc/TCFzaQbr4pbjoTamgXVBa+CxVt1p7lHd6LpNw2FAhJAtzPZNXJuWtjNywYqsyaS6IZTV0UQpw9VjrZcQ3ygTnFGqt5cBZxw5k5fr6ijKTGdemFBRawwAwuUHTqVbFaEv8FrKhsExZjHfCOdlhSgHkuE97ppUfP2el6jD+jmMJrO2CVrkwT1OcEy+r65EDL4kA9ggY9se5UNmRlDbv/Yo7lv3BbwUYwPvick2eq2+eaCFe8CJwHV9c4Sm/K+0wqrg5bruiFXun5j4VoXOEqwVZmlPWwwiAPd+6ECWNdM4KZm7c6TUb3HZoRMwcjCfJ2jDbncmZAHjsol6/6T+s25Rl4sKg0Yk4XE6LtIBe/OnySR4uDyPuy1G/MQBN04w1QsA6EFsLUtDTcJfKx9K/FjDYEAhJ13Km3sQ5P0Vsb1RLJ2al6MZZ9ZCKz00hKRhPy9dO1QxbA2BwZBV9kRNZ2nHo47Rp047IViu3QuopLc7X0gJSQ6WBjENofFgu7oEJ5cjCUwBBOLB/4Gtz3Fg5zfDW6BLXIj7F4YseZak2zrrRceekLIV4wOZzpphz3HZzjANKQwI6kCXIcEPGxo+X/Z
 Wg4kQKIT
 tKroMv8vkjoigx/H4vmGNBsNTHYsJAo51vxJWpv9TcN241e1orWJbe/SDkDOPzxMgL0nLC3cOoRE9ZP1Z8YEv2l+DudvhIcq2TSciRWgx6UImN83ag5ZqwzBsry/bKXNJeeXygNKpWZnapbSsE03FACV3faZN6VjlQ8t+l6SUT3P0hnPu4sBF6NvW38hGUxfPZv/HJ7qRXkQg4aszfSpuNgE0vHmW8yxN/O9MoZkgU6nw+uT0zK2wonMyRQYJa7n3VbV6jPbCueu7u3vmF9H5HjQzqQd6iLkpbZSDpZ6ZlsbKy82uyknBrCY67Bt4XMjH1iDgebwTNk1S5wlBuvdU9ZVJ/q9OtiKiY9ng3KLPJXmce23wlNuMKnwfmh38FTTMQiFn6fiX/Qm1vidOkznlHnkozAJpDB03nsqSOf9CcWwOYYILJJGw69CkH03j6AMc5p4u
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a multi-part message in MIME format.
--------------MKu83Q5FmrLXu5CJIynSSYlh
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 10/31/25 1:18 PM, Pasha Tatashin wrote:
> Sure. Will include it

Thanks a lot. Appreciate your helps.

Yanjun.Zhu


>
> On Fri, Oct 31, 2025, 4:09 PM Yanjun.Zhu <yanjun.zhu@linux.dev> wrote:
>
>     Hi, Pasha
>
>     I noticed that you are moving |kexec_handover.c| from the
>     |kernel/| directory to |kernel/liveupdate/|.
>
>     Several developers suggested that I resend my patch after your
>     patch series is merged upstream.
>     Therefore, I’d like to ask if you could include my patch in your
>     series. This would help avoid extra work on my side to resend the
>     commit later.
>
>     Thanks,
>
>     Yanjun.Zhu
>
>     On 10/21/25 2:41 AM, Simon Horman wrote:
>>     On Thu, Oct 16, 2025 at 08:03:20PM +0000, Zhu Yanjun wrote:
>>>     Make pr_xxx() call to use the %pe format specifier instead of %d.
>>>     The %pe specifier prints a symbolic error string (e.g., -ENOMEM,
>>>     -EINVAL) when given an error pointer created with ERR_PTR(err).
>>>
>>>     This change enhances the clarity and diagnostic value of the error
>>>     message by showing a descriptive error name rather than a numeric
>>>     error code.
>>>
>>>     Signed-off-by: Zhu Yanjun<yanjun.zhu@linux.dev> <mailto:yanjun.zhu@linux.dev>
>>     Thanks,
>>
>>     This looks good to me, even though I note that this file
>>     has moved in linux-next.
>>
>>     Reviewed-by: Simon Horman<horms@kernel.org> <mailto:horms@kernel.org>
>
--------------MKu83Q5FmrLXu5CJIynSSYlh
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: 8bit

<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  </head>
  <body>
    <br>
    <div class="moz-cite-prefix">On 10/31/25 1:18 PM, Pasha Tatashin
      wrote:<br>
    </div>
    <blockquote type="cite"
cite="mid:CA+CK2bD+_QFWx-+3sTW5f-C2tKG+bU1Fzk2bUP39UGuGouPRVA@mail.gmail.com">
      <meta http-equiv="content-type" content="text/html; charset=UTF-8">
      <div dir="auto">Sure. Will include it</div>
    </blockquote>
    <br>
    <p>Thanks a lot. Appreciate your helps.</p>
    <p>Yanjun.Zhu</p>
    <p><br>
    </p>
    <blockquote type="cite"
cite="mid:CA+CK2bD+_QFWx-+3sTW5f-C2tKG+bU1Fzk2bUP39UGuGouPRVA@mail.gmail.com"><br>
      <div class="gmail_quote gmail_quote_container">
        <div dir="ltr" class="gmail_attr">On Fri, Oct 31, 2025, 4:09 PM
          Yanjun.Zhu &lt;<a href="mailto:yanjun.zhu@linux.dev"
            moz-do-not-send="true" class="moz-txt-link-freetext">yanjun.zhu@linux.dev</a>&gt;
          wrote:<br>
        </div>
        <blockquote class="gmail_quote"
style="margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">
          <div>
            <p>Hi, Pasha</p>
            <p>I noticed that you are moving <code>kexec_handover.c</code>
              from the <code>kernel/</code> directory to <code>kernel/liveupdate/</code>.</p>
            <p>Several developers suggested that I resend my patch after
              your patch series is merged upstream.<br>
              Therefore, I’d like to ask if you could include my patch
              in your series. This would help avoid extra work on my
              side to resend the commit later.</p>
            <p>Thanks,</p>
            <p>Yanjun.Zhu</p>
            <div>On 10/21/25 2:41 AM, Simon Horman wrote:<br>
            </div>
            <blockquote type="cite">
              <pre>On Thu, Oct 16, 2025 at 08:03:20PM +0000, Zhu Yanjun wrote:
</pre>
              <blockquote type="cite">
                <pre>Make pr_xxx() call to use the %pe format specifier instead of %d.
The %pe specifier prints a symbolic error string (e.g., -ENOMEM,
-EINVAL) when given an error pointer created with ERR_PTR(err).

This change enhances the clarity and diagnostic value of the error
message by showing a descriptive error name rather than a numeric
error code.

Signed-off-by: Zhu Yanjun <a href="mailto:yanjun.zhu@linux.dev"
                target="_blank" rel="noreferrer" moz-do-not-send="true">&lt;yanjun.zhu@linux.dev&gt;</a>
</pre>
              </blockquote>
              <pre>Thanks,

This looks good to me, even though I note that this file
has moved in linux-next.

Reviewed-by: Simon Horman <a href="mailto:horms@kernel.org"
              target="_blank" rel="noreferrer" moz-do-not-send="true">&lt;horms@kernel.org&gt;</a>
</pre>
            </blockquote>
          </div>
        </blockquote>
      </div>
    </blockquote>
  </body>
</html>

--------------MKu83Q5FmrLXu5CJIynSSYlh--

